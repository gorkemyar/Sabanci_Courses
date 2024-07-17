from multiprocessing import Process
import os
import zmq
import numpy as np
from abc import ABC, abstractmethod
import re
import sys, getopt
import random


class MapReduce(ABC):
    def __init__(self, num_worker : int ): # constructor 
        self.num_worker = num_worker
        self._connection = "tcp://127.0.0.1:"
        self._consumer_arrived_port = 5500
        self._consumer_port = 6000
        self._reduce_port = 5000

    @abstractmethod
    def Map(self, map_input ): #Partial Result 
        raise NotImplementedError
    @abstractmethod
    def Reduce(self, reduce_input): #Result 
        raise NotImplementedError
    
    def _Producer(self, producer_input):
        len_data = len(producer_input) 
        
        context = zmq.Context()
        socket_pull = context.socket(zmq.PULL)        

        address_consumer_arrived = self._connection + str(self._consumer_arrived_port)
        socket_pull.bind(address_consumer_arrived)
        
        # wait for all consumers to be ready
        for i in range(self.num_worker):
            socket_pull.recv_json()
        
        socket_push = context.socket(zmq.PUSH)
        address_list = [self._connection + str(self._consumer_port + i) for i in range(self.num_worker)]
        pieces = [producer_input[i:len_data:self.num_worker] for i in range(self.num_worker)]

        for address in address_list:
            socket_push.connect(address)

        for i in range(self.num_worker):
            work_message = {'a' : pieces[i]}
            socket_push.send_json(work_message)
            


    def _Consumer(self, id):

        print ('Consumer PID:', os.getpid())
        #  Socket to receive messages on port = id 
        context = zmq.Context()
        results_receiver = context.socket(zmq.PULL)
        address_receiver = self._connection + str(self._consumer_port + id) 
        results_receiver.bind(address_receiver)

        #  Socket to send messages to producer so it knows we are ready
        consumer_arrived_sender = context.socket(zmq.PUSH)
        address_arrived_sender = self._connection + str(self._consumer_arrived_port)
        consumer_arrived_sender.connect(address_arrived_sender)
        consumer_arrived_sender.send_json({'a' : 1})

        # Get data from producer
        result = results_receiver.recv_json()['a']
        print("Map", os.getpid(),"Input:",result)
        map_result = self.Map(result)                
        print("Map", os.getpid(),"Result:",map_result)

        # Send result to reducer
        result_sender = context.socket(zmq.PUSH)
        address_sender = self._connection + str(self._reduce_port)
        result_sender.connect(address_sender)
        result_sender.send_json(map_result)


    def _ResultCollector(self):
        print("Result Collector PID:", os.getpid())
        context = zmq.Context()
        results_receiver = context.socket(zmq.PULL)
        address = self._connection + str(self._reduce_port)

        results_receiver.bind(address)
        reduce_list = []
        for i in range(self.num_worker):
            result = results_receiver.recv_json()
            reduce_list.append(result)

        print("Reducer data", reduce_list)
        res = self.Reduce(reduce_list)
        print("Result:", res)

        f = open("results.txt", "w")
        f.write(str(res))
        f.close()


    def start(self, filename):
        # read file
        dir = os.path.dirname(__file__)
        filename = os.path.join(dir, filename)
        sys.path.append(filename)
        f = open(filename, "r")
        data = f.readlines()
        f.close()
        
        input_list = []
        for line in data:
            input_list.append( [int(i) for i in line.strip("\n").split("\t")]) 
        
        print("Initial Data:", input_list)

        producer = Process(target=self._Producer, args=([input_list]))
        reducer = Process(target=self._ResultCollector)
        consumers = []
        for i in range(self.num_worker):
            consumer = Process(target=self._Consumer, args=(i,) )
            consumer.start()
            consumers.append(consumer)

        
        reducer.start()
        producer.start()   
        producer.join()
        
        for consumer in consumers:
            consumer.join()
        
        reducer.join()


