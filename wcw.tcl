set ns  [new Simulator]

#=============================================================================================
#                    	   open the Trace and nam files 				     #
#=============================================================================================

set tf  [open Trace_out.tr w]
$ns trace-all $tf


set nf [open nam_out.nam w]
$ns namtrace-all $nf
$ns namtrace-all-wireless $nf 610 610

#Trace file for plotting congestion window
set f1 [open tahoeCW.tr w]
set f2 [open renoCW.tr w]
set f3 [open vegasCW.tr w]

#Trace file for plotting Throughput
set f0 [open res0.tr w]

set f4 [open tahoeTput.tr w]
set f5 [open renoTput.tr w]
set f6 [open vegasTput.tr w]

set f7 [open scene1.tr w]
set f8 [open scene2.tr w]


#=============================================================================================
#                           set up for hierarchical routing 		                     #
#=============================================================================================


$ns node-config -addressType hierarchical
AddrParams set domain_num_ 4  ;         
lappend cluster_num  1 3 1 1             
AddrParams set cluster_num_ $cluster_num
lappend eilastlevel 1 1 3 2 3 3     
AddrParams set nodes_num_ $eilastlevel 


#=============================================================================================
#                           Creation of Wired Nodes 				 	     #
#=============================================================================================


set num_wired_nodes  2
set node_adds { 0.0.0 1.0.0 }
     
for {set i 0} {$i < $num_wired_nodes} {incr i} {

      set W($i) [$ns node [ lindex $node_adds $i ]]

}

$ns duplex-link $W(0) $W(1) 7Mb 27ms DropTail
$ns duplex-link-op $W(0) $W(1) orient left
$ns queue-limit $W(0) $W(1) 16


#=============================================================================================
#    Define properties of mobile nodes needed for configuration using associative arrays     #
#=============================================================================================

global opt

set opt(chan)       Channel/WirelessChannel
set opt(prop)       Propagation/TwoRayGround
set opt(netif)      Phy/WirelessPhy
set opt(mac)        Mac/802_11
set opt(ifq)        Queue/DropTail/PriQueue
set opt(ll)         LL
set opt(ant)        Antenna/OmniAntenna
set opt(x)             610   
set opt(y)             610   
set opt(ifqlen)         10  
set opt(nn)             9                       
set opt(adhocRouting)   DSDV 
set opt(bs_nn)          4


Antenna/OmniAntenna set X_ 0 
Antenna/OmniAntenna set Y_ 0
Antenna/OmniAntenna set Z_ 0.9
#Antenna/OmniAntenna set Gt_ 1.0
#Antenna/OmniAntenna set Gr_ 1.0

Phy/WirelessPhy set Pt_       0.2818    ;  #transmitted signal power in Watts
Phy/WirelessPhy set RXThresh_ 8.9062e-9 ;  #distance coverage of 60m

Mac/802_11 set dataRate_ 1.4Mb  
LL set delay_ 1us


#=============================================================================================
#     		      configuration and creation of Base Station (Access point)              #
#=============================================================================================

set topo   [new Topography]
$topo load_flatgrid $opt(x) $opt(y)

# god needs to know the number of all wireless interfaces
create-god [ expr $opt(nn) + $opt(bs_nn) ]

$ns node-config  -adhocRouting $opt(adhocRouting) \
		 -mobileIP ON \
                 -llType $opt(ll) \
                 -macType $opt(mac) \
                 -ifqType $opt(ifq) \
                 -ifqLen $opt(ifqlen) \
                 -antType $opt(ant) \
                 -channel [new $opt(chan)] \
                 -propInstance [new $opt(prop)] \
                 -phyType $opt(netif) \
                 -topoInstance $topo \
                 -wiredRouting ON \
                 -agentTrace ON \
                 -routerTrace OFF \
                 -movementTrace OFF \
                 -macTrace ON
                 
set bs_adds { 1.1.0 1.2.0 2.0.0 3.0.0 }

for {set i 0} { $i < $opt(bs_nn) } {incr i} {
       
      set BS($i) [$ns node [ lindex $bs_adds $i ] ]
      $BS($i) shape box
      $BS($i) random-motion 0 ; #disable the random motion

}

#Locating the base station nodes in topography

$BS(0) set X_ 10.0
$BS(0) set Y_ 400.0
$BS(0) set Z_ 0.0

$BS(1) set X_ 210.0
$BS(1) set Y_ 400.0
$BS(1) set Z_ 0.0


$BS(2) set X_ 411.0
$BS(2) set Y_ 400.0
$BS(2) set Z_ 0.0


$BS(3) set X_ 550.0
$BS(3) set Y_ 400.0
$BS(3) set Z_ 0.0


$ns duplex-link $W(1) $BS(0) 3Mb 50ms DropTail
$ns duplex-link $W(1) $BS(1) 3Mb 50ms DropTail
$ns duplex-link $W(0) $BS(2) 2.5Mb 22ms DropTail
$ns duplex-link $W(0) $BS(3) 2.5Mb 22ms DropTail

$ns queue-limit $W(1) $BS(0) 5
$ns queue-limit $W(1) $BS(1) 5
$ns queue-limit $W(0) $BS(2) 8
$ns queue-limit $W(0) $BS(3) 8

#=============================================================================================
#     		      configuration and creation of Mobile Nodes		             #
#=============================================================================================

#configure for mobilenodes
$ns node-config -wiredRouting OFF

set temp { 1.1.1 1.1.2 1.2.1 1.2.2 2.0.1 2.0.2 2.0.3 3.0.1 3.0.2 }

set y 0
set j 0
set xVal { 10 40 210 250 410 430 459 550 590 }
set yVal { 375 375 375 375 380 370 380 375 375 } 

while {$j < 9} {
	
	set MH($j) [ $ns node [lindex $temp $j ] ]
        set home_addr [AddrParams addr2id [$BS($y) node-addr]]
	[$MH($j) set regagent_] set home_agent_ $home_addr
	
	#Locating the wireless nodes in topography

	$MH($j) set X_ [lindex $xVal $j ]
	$MH($j) set Y_ [lindex $yVal $j ]
	$MH($j) set Z_ 0.0

        $ns initial_node_pos $MH($j) 20
        
        if { $j == 1 || $j == 3 || $j == 6 } {
               set y [ expr $y + 1 ]
        }

 	$MH($j) color black
	set j [ expr $j + 1 ]    

}

#=============================================================================================
#     	Creating color classes to distinguish the traffic coming from various sources	     #
#=============================================================================================

$ns color 1 "#000080"; #for udp connection
$ns color 2 "#ff3300" ; #for tcp tahoe connection
$ns color 3 "#00ff99" ; #for tcp Reno connection
$ns color 4 "#0066ff" ; #for tcp Vegas connection
$ns color 5 "#FF5733 " ; #for mip scenario1 (Downloading file when reciever is moving)
$ns color 6 "#ff0066" ; #for mip scenario2 (uploading file when sender is moving)


#=============================================================================================
#     		 Create Necessary Transport Agent and attach it to nodes	             # #=============================================================================================


#UDP Transport layer

set udp [new Agent/UDP]
set null0 [new Agent/LossMonitor]

$ns attach-agent $MH(0) $udp
$ns attach-agent $MH(8) $null0

$ns connect $udp $null0
$udp set fid_ 1


#TCP Transport layer

set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]

$ns attach-agent $MH(1) $tcp1 
$ns attach-agent $MH(4) $sink1

$ns connect $tcp1 $sink1
$tcp1 set fid_ 2

set tcp2 [new Agent/TCP/Reno]
set sink2 [new Agent/TCPSink]

$ns attach-agent $MH(2)  $tcp2   
$ns attach-agent $MH(5)  $sink2
 
$ns connect $tcp2 $sink2
$tcp2 set fid_ 3

set tcp3 [new Agent/TCP/Vegas]
set sink3 [new Agent/TCPSink]

$ns attach-agent $MH(3) $tcp3 
$ns attach-agent $MH(6) $sink3   

$ns connect $tcp3 $sink3
$tcp3 set fid_ 4

set tcp4 [new Agent/TCP]
set sink4 [new Agent/TCPSink]

$ns attach-agent $MH(1) $tcp4  
$ns attach-agent $MH(7) $sink4

$ns connect $tcp4 $sink4
$tcp4 set fid_ 5

set tcp5 [new Agent/TCP/Vegas]
set sink5 [new Agent/TCPSink]

$ns attach-agent $MH(0) $sink5
$ns attach-agent $MH(4) $tcp5 

$ns connect $tcp5 $sink5
$tcp5 set fid_ 6


#=============================================================================================
#    Creating Traffic Agent and attach it to source node     +    Scheduling Events          # #=============================================================================================

proc udp_traffic { } {
        
        global ns udp MH
        
	set cbr [new Application/Traffic/CBR]
	$cbr set packetSize_ 2000 ;
	$cbr set rate_ 512Kb
	$cbr attach-agent $udp

	$ns at 0.5 "$MH(8) color #000080"
	$ns at 0.5 "$MH(0) color #000080"
	
	puts "UDP Connection in wired-Cum-Wireless Network"

	$ns at 0.5 "$cbr start"
	$ns at 45.5 "$cbr stop"

	$ns at 16.1 "$MH(8) setdest 480 310 100"
	$ns at 30.8 "$MH(8) setdest 590 385 100"

	$ns at 45.6 "$MH(0) color black"
	$ns at 45.6 "$MH(8) color black"
}

$ns at 0.3 "udp_traffic"


proc tcp_traffic { } {

	global ns
	global tcp1 tcp2 tcp3
	global MH
	
	$ns at 23.6 "$MH(4) color #ff3300"
	$ns at 23.1 "$MH(5) color #00ff99"
	$ns at 23.6 "$MH(6) color #0066ff"
 	
	$ns at 23.6 "$MH(1) color #ff3300"
	$ns at 23.1 "$MH(2) color #00ff99"
	$ns at 23.6 "$MH(3) color #0066ff"
	
	set ftp1 [new Application/FTP]
	$ftp1 attach-agent $tcp1


	set ftp2 [new Application/FTP]
	$ftp2 attach-agent $tcp2

	set ftp3 [new Application/FTP]
	$ftp3 attach-agent $tcp3

    	puts "TCP Connection in wired-Cum-Wireless Network"
    	
    	$ns at 23.7 "$ftp1 start"
        $ns at 63.0 "$ftp1 stop"
        
        $ns at 23.1 "$ftp2 start"
        $ns at 66.0 "$ftp2 stop"
        
        $ns at 23.7 "$ftp3 start"
        $ns at 65.0 "$ftp3 stop"
	
        $ns at 63.3 "$MH(4) color black"
	$ns at 65.3 "$MH(5) color black"
	$ns at 66.3 "$MH(6) color black"

	$ns at 63.3 "$MH(2) color black"
	$ns at 65.3 "$MH(3) color black"
	$ns at 66.3 "$MH(1) color black"
	
}

$ns at 22.0 "tcp_traffic"

proc mip1 { } {
 	
 	global ns tcp4 MH
 	
	set ftp4 [new Application/FTP]
	$ftp4 attach-agent $tcp4
	
	$ns at 67.6 "$MH(1) add-mark m1 #DC143C circle"
	$ns at 67.6 "$MH(7) add-mark m2 #DC143C circle"

	#downloading file of size 3.5MB
	
	puts "Mobile node moving while receicving data ..."
	
	set filesize [ expr 3.5*1024*1024 ]
	$ns at 68.0 "$ftp4 send $filesize"

	$ns at 98.5 "$MH(7) setdest 230 364 20"
	
	$ns at 138.0 "$MH(1) delete-mark m1"
	$ns at 138.0 "$MH(7) delete-mark m2"

}

$ns at 67.2 "mip1"


proc mip2 { } {

        global ns tcp5 MH
        
	set ftp5 [new Application/FTP]
	$ftp5 attach-agent $tcp5

	$ns at 138.9 "$MH(0) add-mark m1 #00FA9A circle"
	$ns at 138.9 "$MH(4) add-mark m2 #00FA9A circle"
	
	#uploading file of size 1.8MB
	
	puts "Mobile node moving while sending data ..."
	set filesize [ expr 1.8*1024*1024 ]
	$ns at 139.0 "$ftp5 send $filesize"
	

	$ns at 143.0 "$MH(4) setdest 230 350 80"
	$ns at 158.8 "$MH(4) setdest 50 400 70"
	
	$ns at 198.0 "$MH(0) delete-mark m1"
	$ns at 198.0 "$MH(4) delete-mark m2"

}

$ns at 138.6 "mip2"


#=============================================================================================
#  congestionWindow --------> Collecting data for plotting congestion window TCP protocol    # 
#=============================================================================================

proc congestionWindow {} {
	global ns
	global tcp1 tcp2 tcp3
	global f1 f2 f3
	set now [$ns now]
	set time 0.01
	set cwnd1 [$tcp1 set cwnd_]
	puts $f1 "$now $cwnd1"
	set cwnd2 [$tcp2 set cwnd_]
	puts $f2 "$now $cwnd2"
	set cwnd3 [$tcp3 set cwnd_]
	puts $f3 "$now $cwnd3"
	$ns at [expr $now+$time] "congestionWindow"
}

$ns at 22.0 "congestionWindow"

#=============================================================================================
#  throughput --------> Collecting data for ploting graph between Throughput vs Time         # 
#=============================================================================================

proc throughput {} {

	global null0 sink1 sink2 sink3 sink4 sink5
	global f0 f4 f5 f6 f7 f8
	global ns
	
	set time 0.3
	set now [$ns now]
	
	set bw0 [$sink1 set bytes_]
	set bw1 [$sink2 set bytes_]
	set bw2 [$sink3 set bytes_]
        set bw3 [$null0 set bytes_]
        set bw4 [$sink4 set bytes_]
	set bw5 [$sink5 set bytes_]
        
	puts $f4 "$now [expr $bw0/$time*8/1000000]"
	puts $f5 "$now [expr $bw1/$time*8/1000000]"
	puts $f6 "$now [expr $bw2/$time*8/1000000]"
	puts $f0 "$now [expr $bw3/$time*8/1000000]"
	puts $f7 "$now [expr $bw4/$time*8/1000000]"
	puts $f8 "$now [expr $bw5/$time*8/1000000]"

	$sink1 set bytes_ 0
	$sink2 set bytes_ 0
	$sink3 set bytes_ 0
        $null0 set bytes_ 0
        $sink4 set bytes_ 0
	$sink5 set bytes_ 0
	
	
	#Re-schedule the procedure
	$ns at [expr $now+$time] "throughput"
}
$ns at 0.2 "throughput"


#=============================================================================================
#     finish Procedure ----> To end the simulation and close the files          	     #
#=============================================================================================

proc finish {} {

  global ns tf nf f1 f2 f3 f4 f5 f6 f0 f7 f8
  $ns flush-trace
  close $tf
  close $nf
  close $f0
  close $f1
  close $f2
  close $f3
  close $f4
  close $f5
  close $f6
  close $f7
  close $f8
  exit 0
  
}

#=============================================================================================
#     		    Mentioning Start event and stop event in the simulation	             #
#=============================================================================================
for {set i 0 } {$i < $opt(nn) } {incr i} {
      $ns at 199.5 "$MH($i) reset";
}
  
for {set i 0 } {$i < $opt(bs_nn) } {incr i} {
      $ns at 199.5 "$BS($i) reset";
}

$ns at 200.0 "finish"
puts "Starting the Simulation ...."
$ns run
