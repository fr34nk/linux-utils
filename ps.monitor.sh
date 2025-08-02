#!/usr/bin/env bash

source ./helpers.sh


_ps_alert_above_threshold () {
        last=0
        process_media_maximum=${1:-40}

        checkpoint_cycle=5
        cycles_count=0

        declare media_values=();
        while sleep 2; do
                cycles_count=$((cycles_count + 1));

                ps_values=$(_ps_first_values 30);
                ps_values=$(_filter_gt $ps_values 3);
                [[ $DEBUG == true ]] && echo "ps_values: $ps_values";

                media=$(_sum $ps_values)
                [[ $DEBUG == true ]] && echo "media: $media"

                media_values+="$media ";
                [[ $DEBUG == true ]] && echo "media_values: ${media_values[@]}";
                echo "media_values:  $media_values"
                media_of_media=$(_median $media_values);
                echo "media_of_media $media_of_media";

                [[ $DEBUG == true ]] && echo "media_of_media: $media_of_media"

                # Got to checkpoint cycle?
                if [[ $cycles_count == $checkpoint_cycle ]]; then
                        cycles_count=0
                        media_values=()

                        if [[ $media_of_media > $process_media_maximum ]]; then
                                [[ $DEBUG == true ]] && echo "HIT";

                                msg="Current Processes surpassed $process_media_maximum usage"
                                sudo -u liveuser DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "FunctionOutput:_ps_above_threshold" "$msg"

                                dst_log_dir=/var/log/process_usage/
                                if [[ ! -d $dst_log_dir ]]; then
                                        mkdir -p $dst_log_dir;
                                fi
                                cd $dst_log_dir;

                                top -b 2>&1 | head -60 > `_lg $process_usage.log`;

                        fi

                fi

        done
}


