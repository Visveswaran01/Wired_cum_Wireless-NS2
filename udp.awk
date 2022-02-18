BEGIN { 
        
        # variables for pdr calculation
        sendpkts = 0; 
        recvpkts = 0;
        
        # variables for finding tput achieved 
        srt_time = 0;
        end_time = 0;
        flag = 0;
        dataRec = 0;
        
        # variables for finding average e2e delay
        num_samples = 0
	total_delay = 0  
} 
{
	if (($1 == "s") && ($3 == "_6_") && ($4 == "AGT") && ($7 == "cbr"))
	{ 
		#for pdr calculation
		sendpkts++;
		
		#for throughput calculation
		if (flag == 0) 
		{
		  srt_time = $2;
		  flag = 1;
		}
		end_time = $2;
		
		#for avg e2e delay calculation
		stime_arr[$6] = $2;	
	}
	
	if ( ($1 == "r") && ($3 == "_14_") && ($4 == "AGT") && ($7 == "cbr") )
	{ 
		#for pdr calculation
		recvpkts++;
		
		#for throughput calculation
		dataRec += $8; 
		
		#for avg e2e delay calculation
		if (stime_arr[$6] >= 0.0) {
			ind_delay = 0
			etime_arr[$6] = $2
			ind_delay = etime_arr[$6] - stime_arr[$6]
			total_delay += ind_delay
			num_samples += 1
			
		}
		
	}
	
}
END { 
      printf("Throughput Results : \n\n");
      delay = end_time-srt_time;
      tput  = (dataRec*8)/(delay*1000000);
      printf("Throughput Obtained = %f Mbps \n\n",tput);
      
      
      printf("Packet Delivery Ratio Results : \n\n");
      printf("No of packets Sent 	 :   %d\n",sendpkts);
      printf("No of packets Recieved   :   %d\n",recvpkts);
      printf("No of packets dropped 	 :   %d\n",sendpkts-recvpkts);
      printf("Packet delivery Ratio	 :   %f\n",recvpkts/sendpkts);
      
      
      avg_delay = total_delay/num_samples
      printf("\nCalculating end to end delay:\n")
      printf("\nTotal End-to-End Delay = %f " ,total_delay)
      printf("\nAverage End-to-End Delay = %f \n\n" ,avg_delay)
         
}
