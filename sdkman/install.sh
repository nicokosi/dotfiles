echo "Installing SDKMAN! (http://sdkman.io/)"
curl -s "https://get.sdkman.io" | bash

source /home/nkosinski/.sdkman/bin/sdkman-init.sh"

echo "Check that installation succeeded:"
sdk version
