#!/usr/bin/env python3
import os
import sys
from time import sleep

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
                slice_types_counters.append(counter)

    return slice_types_counters

def total_frame_count(p4info_helper, sw, counter_name):
    return list(sw.ReadCounters(p4info_helper.get_counters_id(counter_name), 0))[0].entities[0].counter_entry.data.packet_count

def read_and_print_rates(p4info_helper, s1):
    slice_type_counters = slice_type_counter_values(p4info_helper, s1, "rtspCount")
    slice_type_counters.sort(key=lambda x: x.data.packet_count, reverse=True)
    total_frames = total_frame_count(p4info_helper, s1, "totalFrameCount")

    print(f"Total frames: {total_frames}")
    print("Frame rates:")
    for counter in slice_type_counters:
        print("Type: {:2}\tCount: {}\tRate: {:.2f}%".format(counter.index.index, counter.data.packet_count, counter.data.packet_count / total_frames * 100))


def main():
    # Instantiate a P4Runtime helper from the p4info file
    p4info_helper = p4runtime_lib.helper.P4InfoHelper("./build/h264.p4.p4info.txt")

    s1 = p4runtime_lib.bmv2.Bmv2SwitchConnection(
                name='s1',
                address='127.0.0.1:50051',
                device_id=0,
                proto_dump_file='logs/s1-p4runtime-requests.txt')


    while True:
        os.system('clear') # Clear the terminal
        
        read_and_print_rates(p4info_helper, s1)
        
        sleep(2)

if __name__ == '__main__':
    main()
