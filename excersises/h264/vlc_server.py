import vlc
import time

# Define VLC instance
instance = vlc.Instance("--sout-keep")

# Define VLC player
player = instance.media_player_new()

# Define VLC media
media = instance.media_new('Big_Buck_Bunny_1080_10s_1MB.mp4')  # Here you can replace 'input.mp4' with your video file path

# Set media to the player instance
player.set_media(media)

# Start RTSP Stream
media.add_option(':sout=#rtp{sdp=rtsp://:8554/}')

# Play the video
player.play()

# Keep the stream alive
try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    # Stop the stream on Keyboard Interrupt (Ctrl + C)
    player.stop()
