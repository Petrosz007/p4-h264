# In-Network Investigation of H264 or H265 Streams in P4

## Introduction
In recent years, video streaming has become an increasingly popular means of communication and entertainment, making network efficiency and quality of service (QoS) critical for both providers and users. One way to enhance these aspects is by analyzing and managing video streams directly within the network itself. This one-pager outlines a P4 program designed to perform in-network investigation of H264 or H265 video streams, focusing on real-time streaming protocol (RTSP) with H264 or H265 payloads.

## Background
H264 and H265 are video compression standards widely used in video streaming services. They utilize different frame types for efficient compression: I-frames (key frames), P-frames (refinement frames anchored to previous frames), and B-frames (further refinement frames anchored to previous and future frames). Analyzing and managing these frame types in real-time can help improve network efficiency and QoS.

## Goals
1. Parse I and P frames in real-time within the network.
2. Collect per-stream statistics, such as I-frame rate and P-frame rate.
3. Drop P-frames if the P-frame rate falls below a specified threshold.
4. Optionally, apply Differentiated Services Code Point (DSCP) marking to prioritize traffic.

## Implementation
The P4 program will be developed to process and analyze RTSP packets carrying H264 or H265 payloads. It will identify and parse I and P frames, enabling the collection of per-stream statistics. Based on these statistics, the program will determine whether to drop P-frames if their rate is below the predefined threshold, or to apply DSCP marking for traffic prioritization.

### Key Components
1. **Frame identification and parsing**: The P4 program will identify and parse I and P frames by examining packet headers and payload information. This will be crucial for collecting frame-related statistics.
2. **Per-stream statistics collection**: The program will maintain a table to record I-frame and P-frame rates for each stream, enabling real-time monitoring and analysis.
3. **P-frame rate threshold enforcement**: The P4 program will compare the P-frame rate with a predefined threshold. If the rate is below the threshold, the program will drop the P-frames to maintain QoS.
4. **DSCP marking (optional)**: The P4 program can optionally use DSCP marking to prioritize traffic based on the collected statistics, ensuring optimal network performance.

## Conclusion
The proposed P4 program aims to improve network efficiency and QoS by performing real-time in-network investigation of H264 or H265 video streams. By parsing I and P frames, collecting per-stream statistics, and applying threshold-based P-frame rate enforcement or DSCP marking, the program can effectively manage video streams and optimize network performance.
