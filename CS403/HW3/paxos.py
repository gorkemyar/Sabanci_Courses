from multiprocessing import Process, Manager
import os
import zmq
import numpy as np
from abc import ABC, abstractmethod
import re
import sys, getopt
import random

# Broadcasts a message to all nodes except the sender
def broadcast(msg, sender, socket_list):
    for i, socket in enumerate(socket_list):
        if i != sender:
            send(msg, socket)

# Sends a message to a node
def send(msg, socket):
    json = {'msg': msg}
    socket.send_json(json)

# Broadcasts a message to all nodes with a probability of failure
def broadcastFailure(msg, leader, socket_list, prob):
    for socket in socket_list:
        sendFailure(msg, leader, socket, prob)

# Sends a message to a node with a probability of failure
def sendFailure(msg, leader, socket, prob):
    if failure(prob):
        msg = "CRASH " + str(leader)
    json = {'msg': msg}
    socket.send_json(json)

# Returns true with a probability of prob
def failure(prob):
    return random.random() < prob

def paxosNode(ID, prob, N, val, numRounds, barrier):
    max_voted_round = -1
    max_voted_val = None
    decision = None
    propose_val = None

    # initialize sockets
    context = zmq.Context()
    pull_socket = context.socket(zmq.PULL)
    pull_socket.bind("tcp://127.0.0.1:%s" % (5500 + ID))

    push_sockets = []
    for i in range(N):
        push_socket = context.socket(zmq.PUSH)
        push_socket.connect("tcp://127.0.0.1:%s" % (5500 + i))
        push_sockets.append(push_socket)
    
    # start paxos
    for r in range(numRounds):
        leader = ID == (r % N)
        if leader: # leader
            print("ROUND %d STARTED WITH INITIAL VALUE: %d" % (r, val))
            broadcastFailure("START", ID, push_sockets, prob)
            return_count, join_count, msg_list = 0, 0, []

            while return_count < N: # wait for all nodes to return
                json = pull_socket.recv_json()
                print("LEADER OF %d RECEIVED IN JOIN PHASE: %s" % (r, json['msg']))
                msg_list.append(json)
                return_count += 1
                if "JOIN" in json['msg'] or json['msg'] == "START":
                    join_count += 1
            
            if join_count > N/2: # enough nodes joined
                tmp_val = None
                tmp_round = -1
                
                for msg in msg_list:
                    if "JOIN" in msg['msg']: 
                        join_msgs = msg['msg'].split(" ")
                        if int(join_msgs[1]) > tmp_round and join_msgs[2] != "None":
                            tmp_round = int(join_msgs[1])
                            tmp_val = int(join_msgs[2])  
                        
                    if msg['msg'] == "START" and max_voted_round != -1:
                        if max_voted_round > tmp_round:
                            tmp_round = max_voted_round
                            tmp_val = max_voted_val
                
                
                if tmp_round == -1 and max_voted_round == -1:
                    propose_val = val
                else:
                    propose_val = tmp_val     

                broadcastFailure("PROPOSE " + str(propose_val), ID, push_sockets, prob)
                return_count, join_count, msg_list = 0, 0, []
                while return_count < N: # wait for all nodes to return
                    print("LEADER OF %d RECEIVED IN VOTE PHASE: %s" % (r, json['msg']))
                    json = pull_socket.recv_json()
                    msg_list.append(json)
                    return_count += 1
                    if json['msg'] == "VOTE":
                        join_count += 1
                    elif "PROPOSE" in json['msg']:
                        join_count += 1
                        max_voted_round = r
                        max_voted_val = propose_val

                if join_count > N/2:
                    decision = propose_val
                    print("LEADER OF %d DECIDED ON VALUE: %s" % (r, decision))
                else:
                    print("LEADER OF %d DID NOT DECIDE ON VALUE" % (r))

            else: # not enough nodes joined
                broadcast("ROUNDCHANGE", ID, push_sockets)
                print("LEADER OF ROUND %d CHANGED ROUND" % (r))
            
            barrier.wait() # wait for other nodes to join
                
        else: # not leader
            json = pull_socket.recv_json()
            print("ACCEPTOR %d RECEIVED IN JOIN PHASE: %s" % (ID, json['msg']))
            if json['msg'] == "START":
                msg = "JOIN " + str(max_voted_round) + " " + str(max_voted_val)
                sendFailure(msg, r % N, push_sockets[r % N], prob)
                    
            elif "CRASH" in json['msg']:
                send(json['msg'], push_sockets[r % N])
            
            json = pull_socket.recv_json()
            print("ACCEPTOR %d RECEIVED IN VOTE PHASE: %s" % (ID, json['msg']))
            if "PROPOSE" in json['msg']:
                max_voted_round = r
                max_voted_val = json['msg'].split(" ")[1]
                sendFailure("VOTE", r % N, push_sockets[r % N], prob)
            elif "CRASH" in json['msg']:
                send(json['msg'], push_sockets[r % N])
            elif json['msg'] == "ROUNDCHANGE":
                pass
            
            ### In all cases, wait for other nodes to join
            barrier.wait() 

if __name__ == "__main__":
    # get parameters from command line
    try:
        if len(sys.argv) != 4:
            print("Invalid number of arguments")
            exit(1)
        
        num_proc = int(sys.argv[1])
        prob = float(sys.argv[2])
        num_rounds = int(sys.argv[3])

        print("NUM NODES: ", num_proc, ", CRASH PROB: ", prob, ", NUM ROUNDS: ", num_rounds, sep="")

        manager = Manager()
        barrier = manager.Barrier(num_proc)
        paxos_nodes = [Process(target=paxosNode, args=(i, prob, num_proc, random.randint(0, 1), num_rounds, barrier)) for i in range(num_proc)]

        for node in paxos_nodes:
            node.start()
        for node in paxos_nodes:
            node.join()
        
        print("End of program")

    except Exception as e:
        print("Error")
        print(e)
        exit(1)