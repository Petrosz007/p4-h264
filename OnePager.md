# In-Network Investigation of H264 or H265 Streams in P4

## Introduction
In recent years, video streaming has become an increasingly popular means of communication and entertainment, making network efficiency and quality of service (QoS) critical for both providers and users. One way to enhance these aspects is by analyzing and managing video streams directly within the network itself. This one-pager outlines a P4 program designed to perform in-network investigation of H264 or H265 video streams, focusing on real-time streaming protocol (RTSP) with H264 or H265 payloads.

## Background
H264 and H265 are video compression standards widely used in video streaming services. They utilize different frame types for efficient compression: I-frames (key frames), P-frames (refinement frames anchored to previous frames), and B-frames (further refinement frames anchored to previous and future frames). Analyzing and managing these frame types in real-time can help improve network efficiency and QoS.

## Goals
1. Parse I and P frames in real-time within the network.
2. Collect per-stream statistics, such as I-frame rate and P-frame rate.

## Implementation
The P4 program will be developed to process and analyze [RTSP packets](https://www.ietf.org/rfc/rfc2326.txt) carrying [H264](https://datatracker.ietf.org/doc/html/rfc6184) or H265 payloads. It will identify and parse I and P frames, enabling the collection of per-stream statistics. Based on these statistics.

### Key Components
1. **Frame identification and parsing**: The P4 program will identify and parse I and P frames by examining packet headers and payload information. This will be crucial for collecting frame-related statistics.
2. **Per-stream statistics collection**: The program will maintain a table to record I-frame and P-frame rates for each stream, enabling real-time monitoring and analysis.

### Implementation Approach
To achieve the aforementioned goals, we plan to implement the following approach:

1. **Custom packet type**: We will introduce a custom packet type that includes RTSP url for retrieving rate statistics, such as I-frame and P-frame rates.
2. **Frame identification and rate updating**: When a video stream frame arrives, the P4 program will identify whether it is an I-frame or a P-frame. Based on the identification, the program will update the respective rate counters in the using registers.

By implementing these additional features, the P4 program will be able to efficiently process and manage H264 or H265 video streams within the network.

## Conclusion
The proposed P4 program aims to improve network efficiency and QoS by performing real-time in-network investigation of H264 or H265 video streams. By parsing I and P frames, collecting per-stream statistics.
