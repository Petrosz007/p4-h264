#!/usr/bin/env python3
import argparse
import os
import sys
from time import sleep

import grpc

# Import P4Runtime lib from parent utils dir
# Probably there's a better way of doing this.
sys.path.append(
    os.path.join(os.path.dirname(os.path.abspath(__file__)),
                 '../../utils/'))
import p4runtime_lib.bmv2
import p4runtime_lib.helper
from p4runtime_lib.switch import ShutdownAllSwitchConnections

def slice_type_counter_values(p4info_helper, sw, counter_name):
    slice_types_counters = []
    for response in sw.ReadCounters(p4info_helper.get_counters_id(counter_name), None):
        for entity in response.entities:
            counter = entity.counter_entry
            if counter.data.packet_count != 0:
                # print("%s %s %d: %d packets (%d bytes)" % (
                #     sw.name, counter_name, counter.index.index,
                #     counter.data.packet_count, counter.data.byte_count
                # ))
                slice_types_counters.append(counter)

    return slice_types_counters

def total_packet_count(p4info_helper, sw, counter_name):
    return list(sw.ReadCounters(p4info_helper.get_counters_id(counter_name), 0))[0].entities[0].counter_entry.data.packet_count

########
## MAIN
########

# Instantiate a P4Runtime helper from the p4info file
p4info_helper = p4runtime_lib.helper.P4InfoHelper("./build/h264.p4.p4info.txt")

s1 = p4runtime_lib.bmv2.Bmv2SwitchConnection(
            name='s1',
            address='127.0.0.1:50051',
            device_id=0,
            proto_dump_file='logs/s1-p4runtime-requests.txt')

slice_type_counters = slice_type_counter_values(p4info_helper, s1, "rtspCount")
total_packets = total_packet_count(p4info_helper, s1, "totalPacketCount")

print(f"Total packets: {total_packets}")
print("Packet rates:")
for counter in slice_type_counters:
    print("Type: {} Count: {} Rate: {:.2f}%".format(counter.index.index, counter.data.packet_count, counter.data.packet_count / total_packets * 100))