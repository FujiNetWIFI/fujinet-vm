#!/usr/bin/env bash
set -x

sudo apt-get install -y epiphany-browser figlet

mkdir "/home/$P_USERNAME/Desktop"
mkdir "/home/$P_USERNAME/Pictures"
mkdir "/home/$P_USERNAME/Downloads"
mkdir "/home/$P_USERNAME/Documents"
mkdir -p "/home/$P_USERNAME/.local/bin"
mkdir -p "${P_FN_PATH:-/home/$P_USERNAME/FujiNet}"

if [[ "$PACKER_BUILD_TYPE" == "qemu"  ]]
then
  MONITOR="monitorVirtual-1"
else 
  MONITOR="monitorVirtual1"
fi

DISABLE_LIGHT_LOCKER_PATH="/home/$P_USERNAME/.config/autostart/light-locker.desktop"

cp /tmp/wallpaper.png "/home/$P_USERNAME/Pictures/wallpaper.png"
#cp /tmp/fn-logo-black.png "/home/$P_USERNAME/Pictures/fn-logo-black.png"

cat <<EOF | sudo tee /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml 
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="$MONITOR" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="1"/>
          <property name="image-style" type="int" value="4"/>
          <property name="last-image" type="string" value="/home/$P_USERNAME/Pictures/wallpaper.png"/>
          <property name="rgba1" type="array">
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="1"/>
          </property
          <property name="rgba2" type="array">
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="1"/>
          </property
        </property>
      </property>
    </property>
  </property>
</channel>
EOF

cat <<EOF | sudo tee /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml 
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="workspace_count" type="int" value="1"/>
  </property>
</channel>
EOF

mkdir -p .config/autostart
cat <<EOF > "$DISABLE_LIGHT_LOCKER_PATH"
[Desktop Entry]
Hidden=true
EOF
