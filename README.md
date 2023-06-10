# P4 H.264

Check the plan in the [packet_juggling/README.md](packet_juggling/README.md) file.

## How to run the example

Open the project inside an environment where P4 is available. It can be done with the provided Dockerfile. There is a devcontainer definition, so it is easiest to do inside VS Code with the Remote Containers extension.

1. Open two terminal windows.
2. In the first, start mininet and start sending the packets with RTSP and H.264:
    ```sh
    cd excersises/h264
    make
    h1 python3 send_stream.py
    ```
3. In the second terminal you can start reading the counters and stream statistics
    ```sh
    cd excersises/h264
    ./read_counters.py
    ```

You can a see real time statistics about the H.264 frames. It shows the total number of frames, and the rate and count of each slice type. More on the slice types later.

Here is an example:
```
Total frames: 613
Frame rates:
Type:  7        Count: 285      Rate: 46.49%
Type: 23        Count: 244      Rate: 39.80%
Type:  0        Count: 57       Rate: 9.30%
Type: 16        Count: 6        Rate: 0.98%
Type: 31        Count: 6        Rate: 0.98%
Type: 12        Count: 3        Rate: 0.49%
Type:  3        Count: 2        Rate: 0.33%
Type: 26        Count: 2        Rate: 0.33%
Type:  2        Count: 1        Rate: 0.16%
Type: 11        Count: 1        Rate: 0.16%
Type: 17        Count: 1        Rate: 0.16%
Type: 18        Count: 1        Rate: 0.16%
Type: 19        Count: 1        Rate: 0.16%
Type: 21        Count: 1        Rate: 0.16%
Type: 24        Count: 1        Rate: 0.16%
Type: 25        Count: 1        Rate: 0.16%
```

## How the implementation works

The `send_stream.py` file, executed inside mininet, uses `tcpreplay` to create the RTSP stream. We have previously captured this RTSP stream with Wireshark.

RTSP streams need an RTSP server. It was run with the [rtsp-server.docker-compose.yaml](rtsp-server.docker-compose.yaml) file inside docker. By running the `excersises/h264/stream.py` script (from that directory) we were able to create this stream. Capturing the packets can only be done on the 'client' side. We opened the stream inside VLC and recorded the packets with Wireshark.

In the P4 file we created a parser for RTSP, RTP and H.264 headers. After following some RFC documents we found that the `sliceType` can tell us what kind of H.264 frame is inside the packet.

Unfortunately we couldn't figure out a way to convert the slice types to readable frame types (like P, I, B frames). The slice types have to be converted to NAL unit types. These NAL unit types can then be converted to frame types, as seen in this table (Source: https://stackoverflow.com/a/22559278)
![NAL unit type to frame type table](nal_unit_type_table.jpg)

The problem we had, is we couldn't find algorithms to convert slice types to NAL unit types. "There is no one to one mapping of specific bit, esp. at fixed position from the beginning of the "frame" that says it's I/P/B frame. " Source: https://stackoverflow.com/a/22559278 

We found a guide detailing how NAL unit types work, but implementing that didn't work. https://yumichan.net/video-processing/video-compression/introduction-to-h264-nal-unit/

From looking at the packets in Wireshark we concluded, that slice type 7 is a B frame and 23 is a P frame.

We only a packet, when the `fuHeaderStart` bit is 1. This means, that this packet contains the start of a frame. This way we can distinguish packets and frames.

