// My open GitHub pull requests, grouped. Left click: go to the PR's Herdr space; right click: the PR on GitHub.
import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { exec, home, spaces, panes, run, notify, theme, checking } from "herdr";
import { fetchGroups, openPr } from "./open.js";

const REFRESH_MS = 300000;
const SECTIONS = [{ id: "mine", title: "Mes PR" }, { id: "contrib", title: "Je contribue" }];
const deps = () => ({ exec, home: home(), spaces, panes, run, notify });

export default class Prs extends View {
  init(_props, cx) {
    this.groups = [];
    this.error = null;
    this.loading = false;
    this.loaded = false;
    this.opening = new Set();
    if (checking()) return;
    cx.timer.every(REFRESH_MS, (cx) => this.refresh(cx));
    this.refresh(cx);
  }

  refresh(cx) {
    if (this.loading) return;
    this.loading = true;
    cx.notify();
    cx.spawn(async (cx) => {
      try {
        this.groups = await fetchGroups(deps());
        this.error = null;
        this.loaded = true;
      } catch (e) {
        this.error = e?.message ?? String(e);
      }
      this.loading = false;
      cx.notify();
    });
  }

  open(pr, cx) {
    this.opening.add(pr.url);
    cx.notify();
    cx.spawn(async (cx) => {
      try {
        await openPr(pr, deps());
      } catch (e) {
        notify({ title: `${pr.repo}#${pr.number}`, body: e?.message ?? String(e), level: "error" });
      }
      this.opening.delete(pr.url);
      cx.notify();
    });
  }

  row(t, pr) {
    const busy = this.opening.has(pr.url);
    return v_flex()
      .id(`pr-${pr.url}`)
      .px(8)
      .py(4)
      .gap(1)
      .rounded(7)
      .hover((s) => s.bg(t.hover))
      .on_click((_e, cx) => this.open(pr, cx))
      .on_mouse_down("right", () => { exec("xdg-open", [pr.url]); })
      .child(div().text_size(12.8).text_color(t.foreground).truncate().child(pr.title))
      .child(div().text_size(11).text_color(t.dim).truncate().child(busy ? `${pr.repo}#${pr.number} · ouverture…` : `${pr.repo}#${pr.number}`));
  }

  render(cx) {
    const t = theme();
    const sections = SECTIONS.map((s) => ({ ...s, groups: this.groups.filter((g) => g.section === s.id) })).filter((s) => s.groups.length);
    return v_flex()
      .size_full()
      .bg(t.chrome)
      .child(h_flex()
        .h(40)
        .px(12)
        .flex_none()
        .items_center()
        .justify_between()
        .child(div().text_size(13).font_semibold().text_color(t.foreground).child("Pull requests"))
        .child(div()
          .id("refresh")
          .px(8)
          .py(3)
          .rounded(6)
          .text_size(11.5)
          .text_color(t.muted)
          .hover((s) => s.bg(t.hover))
          .on_click((_e, cx) => this.refresh(cx))
          .child(this.loading ? "…" : "Rafraîchir")))
      .when(this.error !== null, (el) => el.child(div().px(12).pb(6).text_size(11.5).text_color(t.blocked).child(this.error)))
      .child(v_flex()
        .id("list")
        .flex_1()
        .px(4)
        .pb(8)
        .gap(2)
        .overflow_y_scrollbar()
        .when(this.loaded && !sections.length, (el) => el.child(div().px(8).text_size(12).text_color(t.muted).child("Aucune PR")))
        .children(sections.flatMap((s) => [
          div().px(8).pt(10).text_size(11).font_semibold().text_color(t.muted).child(s.title.toUpperCase()),
          ...s.groups.flatMap((g) => [
            div().px(8).pt(6).pb(2).text_size(11.5).text_color(t.accent).child(`${g.title} · ${g.prs.length}`),
            ...g.prs.map((pr) => this.row(t, pr)),
          ]),
        ])));
  }
}
