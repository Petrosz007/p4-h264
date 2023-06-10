#include <core.p4>
#include <v1model.p4>

#define MAX_NAL_UNIT_TYPE 32
#define MAX_SLICE_TYPE 63

typedef bit<5> slice_type;
typedef bit<5> nal_unit_type;
const bit<16> TYPE_IPV4 = 0x800;

header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<8>  diffserv;
    bit<16> totalLen;
    bit<16> identification;
    bit<3>  flags;
    bit<13> fragOffset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> hdrChecksum;
    bit<32> srcAddr;
    bit<32> dstAddr;
}

header tcp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  ctrl;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}

header rtsp_interleaved_t {
    bit<8> magic;
    bit<8> channel;
    bit<16> length;
}

header rtp_t {
    bit<2> version;
    bit<1> padding;
    bit<1> extension;
    bit<4> csrcCount;
    bit<1> marker;
    bit<7> payloadType;
    bit<16> sequenceNumber;
    bit<32> timestamp;
    bit<32> ssrcId;
}

header h264_t {
    bit<1> fuIdFBit;
    bit<2> fuIdFNRI;
    bit<5> fuIdFFUA;
    bit<1> fuHeaderStart;
    bit<1> fuHeaderEnd;
    bit<1> fuHeaderForbidden;
    nal_unit_type fuHeaderNALUnitType; // <-- Nah, maybe this?
    bit<1> nalFirst;
    slice_type sliceType; // <-- This is what we need
    bit<2> padding;
}

struct headers {
    ethernet_t ethernet;
    ipv4_t     ipv4;
    tcp_t      tcp;
    rtsp_interleaved_t rtsp_interleaved;
    rtp_t rtp;
    h264_t h264;
}

struct metadata {
    /* In our case it is empty */
}

// Register array
counter(MAX_SLICE_TYPE, CounterType.packets) rtspCount;
counter(1, CounterType.packets) totalFrameCount;

parser MyParser(packet_in packet, 
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {
    state start {
        transition parse_ethernet;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        // transition select(hdr.ethernet.etherType) {
        //     TYPE_IPV4: parse_ipv4;
        //     default: accept;
        // }
        transition parse_ipv4;
    }

    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition parse_tcp;
    }

    state parse_tcp {
        packet.extract(hdr.tcp);
        transition parse_rtsp_interleaved;
    }

    state parse_rtsp_interleaved {
        packet.extract(hdr.rtsp_interleaved);
        transition parse_rtp;
    }

    state parse_rtp {
        packet.extract(hdr.rtp);
        transition parse_h264;
    }

    state parse_h264 {
        packet.extract(hdr.h264);
        transition accept;
    }
}

control MyVerifyChecksum(inout headers hdr,
                         inout metadata meta) {
    apply { }
}

control MyIngress(inout headers hdr, 
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    apply {
        if(hdr.h264.isValid() && hdr.h264.fuHeaderStart == 1) {
            totalFrameCount.count(0);
            rtspCount.count((bit<32>) hdr.h264.sliceType);
        }

        // if(hdr.ethernet.isValid()) {
        //     rtspCount.count(10);
        // }
        // if(hdr.ipv4.isValid()) {
        //     rtspCount.count(11);
        // }
        // if(hdr.tcp.isValid()) {
        //     rtspCount.count(12);
        // }
        // if(hdr.rtsp_interleaved.isValid()) {
        //     rtspCount.count(13);
        // }
        // if(hdr.rtp.isValid()) {
        //     rtspCount.count(14);
        // }
        // if(hdr.h264.isValid()) {
        //     rtspCount.count(15);
        // }
    }
}

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply { }
}

control MyComputeChecksum(inout headers hdr, inout metadata meta) {
    apply { }
}


control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.tcp);
        packet.emit(hdr.rtsp_interleaved);
        packet.emit(hdr.rtp);
        packet.emit(hdr.h264);
    }
}



V1Switch(
    MyParser(), 
    MyVerifyChecksum(),
    MyIngress(), 
    MyEgress(),
    MyComputeChecksum(),
    MyDeparser()
) main;
