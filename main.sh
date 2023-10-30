#! /bin/bash
main() {
        echo "--------------------------"
        echo "User Name: LimJunHyeon"
        echo "Student Number: 12201839"
        echo "[ MENU ]"
        echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
        echo "2. Get the data of action genre movies from 'u.item'"
        echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
        echo "4. Delete the 'IMDb URL' from 'u.item'"
        echo "5. Get the data about users from 'u.user'"
        echo "6. Modify the format of 'release date' in 'u.item'"
        echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
        echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
        echo "9. Exit"
        echo "--------------------------"

    while :
    do
        read -p "Enter your choice [ 1-9 ] " choice
        echo
        case $choice in
            1)
                read -p "Please enter 'movie id'(1~1682):" m_id
                echo
                awk -F\| -v m_id=$m_id '$1 == m_id {print}' $1
                echo
                ;;
            2)
                read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n):" approve
                echo
                if [ $approve = "y" ]
                then awk -F\| '$7 == 1 { print $1, $2 }' $1| sort -n | head -10
                    echo
                fi
                ;;
            3)
                read -p "Please enter the 'movie id'(1~1682):" m_id
                avg_rank=$(awk -F'\t' -v id=$m_id '$2 == id { sum += $3; cnt+=1; } END { if (cnt > 0) print sum/cnt }' $2)
                echo "average rating of $m_id: $avg_rank"
                echo
                ;;
            4)
                read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):" approve
                echo
                if [ "$approve" = "y" ]
                then
                    sed -E 's/^(([^|]*\|){4})[^|]*\|/\1|/' $1 | head -10
                    echo
                fi
                ;;
            5)
                read -p "Do you want to get the data about users from 'u.user'?(y/n):" approve
                echo
                if [ "$approve" = "y" ]
                then
            sed -n 's/^\([0-9]*\)|\([0-9]*\)|\(M\)|\([^|]*\)|.*/user \1 is \2 years old male \4/p; s/^\([0-9]*\)|\([0-9]*\)|\(F\)|\([^|]*\)|.*/user \1 is \2 years old female \4/p' $3 | head -10



                    echo
                fi
                ;;
            6)
                read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n):" approve
                echo
                if [ "$approve" = "y" ]
                then
                    sed -n 's/\([0-9][0-9]\)-\(...\)-\([0-9][0-9][0-9][0-9]\)/\3\2\1/p' $1 | tail -10 | sed 's/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/;s/Jun/06/; s/Jul/07/; s/Aug/08/; s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/'
                    echo
                fi
                ;;
            7)
                echo
read -p "Please enter the ‘user id’(1~943):" u; echo
m_ids=$(awk -v uid="$u" '$1 == uid {print $2}' $2 | sort -n)
echo $m_ids | tr ' ' '|'; echo

for mid in $(echo "$m_ids" | head -n 10); do
    awk -F\| -v id=$mid '$1==id {print $1 "|" $2}' $1
done; echo

                ;;
            8)
                read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" approve
                echo
                if [ "$approve" = "y" ]; then
                    u_ids=$(awk -F\| '$2 >= 20 && $2 <= 29 && $4 == "programmer" {print $1}' $3)
                    awk -F'\t' -v users="$u_ids" 'NR==1 { split(users, arr, "\n"); for (i in arr) key[arr[i]] } $1 in key { sum[$2] += $3; cnt[$2]+=1; }
                    END {
                        for (movie in sum) {
                            avg = sum[movie];
                avg /= cnt[movie];
                            print movie, avg
                        }
                    }' $2 | sort -k1n
                    echo
                fi
                ;;
        9)
                echo "Bye!"
                echo
                exit 0
                ;;
        esac
    done
}

main $1 $2 $3