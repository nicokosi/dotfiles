# Stash your environment variables in ~/.env-vars. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
#
# Note: This is an alternative to ~/.localrc (which is loaded earlier).
# Use ~/.localrc for general secrets, or ~/.env-vars specifically for exports.
# See SECURITY.md for details.
if [[ -a ~/.env-vars ]]
then
  source ~/.env-vars
fi

