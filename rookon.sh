#!/usr/bin/env bash

kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-mon-c                   
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-mon-b                   
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-mon-a                   
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-mgr-b                   
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-mgr-a                   
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-osd-3                   
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-osd-2                   
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-osd-1                   
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-osd-0                   
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-mgr-b                   
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-mgr-a                   
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-exporter-k0s-node3      
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-exporter-k0s-node2      
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-exporter-k0s-node1      
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-crashcollector-k0s-node3
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-crashcollector-k0s-node2
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-crashcollector-k0s-node1
kubectl -n rook-ceph scale --replicas=2 deployment csi-rbdplugin-provisioner         
kubectl -n rook-ceph scale --replicas=2 deployment csi-cephfsplugin-provisioner      

kubectl -n rook-ceph exec -it deployment.apps/rook-ceph-tools -- ceph osd unset pause
kubectl -n rook-ceph exec -it deployment.apps/rook-ceph-tools -- ceph osd unset nodown
kubectl -n rook-ceph exec -it deployment.apps/rook-ceph-tools -- ceph osd unset norebalance
kubectl -n rook-ceph exec -it deployment.apps/rook-ceph-tools -- ceph osd unset norecover
kubectl -n rook-ceph exec -it deployment.apps/rook-ceph-tools -- ceph osd unset nobackfill
kubectl -n rook-ceph exec -it deployment.apps/rook-ceph-tools -- ceph osd unset noout

kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-operator

