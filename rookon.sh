#!/bin/bash

set -x

# Unpatch, and re-enable the daemonsets
DAEMONSET_LIST="csi-cephfsplugin csi-rbdplugin rook-discover"
for i in $DAEMONSET_LIST; do
	kubectl -n rook-ceph patch daemonset $i --type json -p='[{"op": "remove", "path": "/spec/template/spec/nodeSelector/nonexisting"}]'
done


# Scale up all the deployments
DEPLOYMENTLIST="csi-cephfsplugin-provisioner
csi-rbdplugin-provisioner
rook-ceph-crashcollector-k0s-node1
rook-ceph-crashcollector-k0s-node2
rook-ceph-crashcollector-k0s-node3
rook-ceph-crashcollector-k0s-node4
rook-ceph-exporter-k0s-node1
rook-ceph-exporter-k0s-node2
rook-ceph-exporter-k0s-node3
rook-ceph-exporter-k0s-node4
rook-ceph-mgr-a
rook-ceph-mgr-b
rook-ceph-osd-0
rook-ceph-osd-1
rook-ceph-osd-2
rook-ceph-osd-3
rook-ceph-mgr-a
rook-ceph-mgr-b
rook-ceph-mon-a
rook-ceph-mon-b
rook-ceph-mon-c"

for i in `echo $DEPLOYMENTLIST | tac`; do
	kubectl -n rook-ceph scale --replicas=1 deployment $i
	sleep 5
done

# Unset the OSD params
OSD_PARAMS="pause nodown norebalance norecover nobackfill noout"
for i in $OSD_PARAMS; do
kubectl -n rook-ceph exec -it deployment.apps/rook-ceph-tools -- ceph osd unset $i
sleep 1
done

# Scale Up the rook operator
kubectl -n rook-ceph scale --replicas=1 deployment rook-ceph-operator

