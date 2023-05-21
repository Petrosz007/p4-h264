# import ffmpeg

# input_file = 'Big_Buck_Bunny_1080_10s_1MB.mp4'
# output_url = 'rtsp://localhost:8554/stream'


# (
#     ffmpeg
#     .input(input_file)
#     .output(output_url, vcodec='copy', f='rtsp', muxdelay='0.1')
#     .run_async()
# )

import os

# input_file = 'Big_Buck_Bunny_720_10s_2MB.mp4'
input_file = '/workspaces/p4-h264/excersises/h264/Big_Buck_Bunny_720_10s_2MB.mp4'
output_url = 'rtsp://localhost:8554/stream'

os.system(f"ffmpeg -re -stream_loop -1 -i {input_file} -vcodec libx264 -f rtsp -muxdelay 0.1 {output_url}")
