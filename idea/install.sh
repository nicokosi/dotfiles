echo "# For an intelligent IDE, it is essential to be in the know about any external changes in files it is working with - e.g. changes made by VCS, or build tools, or code generators etc. For that reason, IntelliJ platform spins background process to monitor such changes. The method it uses is platform-specific, and on Linux, it is the Inotify facility. Inotify requires a "watch handle" to be set for each directory in the project. Unfortunately, the default limit of watch handles may not be enough for reasonably sized projects, and reaching the limit will force IntelliJ platform to fall back to recursive scans of directory trees. To prevent this situation it is recommended to increase the watches limit (to, say, 512K)
# cf. https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/idea.conf
sysctl -p --system
