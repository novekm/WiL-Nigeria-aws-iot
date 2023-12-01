# Make bin directory and change back to minipupper-iot directory
cd ../.. && mkdir bin && cd environment/minipupper-iot

# Install Arduino CLI
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/home/ec2-user/bin sh

# Create config ile
arduino-cli config init

# Add M5StickCPlus board to config file
arduino-cli config add board_manager.additional_urls https://m5stack.oss-cn-shenzhen.aliyuncs.com/resource/arduino/package_m5stack_index.json

# Install board core
arduino-cli core install m5stack:esp32@2.0.7

# Install pyserial
pip3 install pyserial

# Install libraries
arduino-cli lib install M5StickCPlus

arduino-cli lib install MQTT

arduino-cli lib install ElegantOTA

echo Setup finished successfully!
