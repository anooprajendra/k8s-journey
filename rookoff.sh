#!/bin/bash

set -x

# Scale down the rook-ceph-operator
kubectl -n rook-ceph scale --replicas=0 deployment rook-ceph-operator

# Unset all the ceph OSD params
OSD_PARAMS="noout nobackfill norecover norebalance nodown pause"
for i in $OSD_PARAMS; do
	kubectl -n rook-ceph exec -it deployment.apps/rook-ceph-tools -- ceph osd unset $i
	sleep 1
done

read -p "Continue (Y/N)? " cont
if [ ${cont,} != "y" ]; then
	exit 0
fi

# Scale down all the deployments
DEPLOYMENTLIST="csi-cephfsplugin-provisioner
csi-rbdplugin-provisioner
rook-ceph-crashcollector-k0s-node1
rook-ceph-crashcollector-k0s-node2
rook-ceph-crashcollector-k0s-node3
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
rook-ceph-mon-c
rook-ceph-operator"

for i in $DEPLOYMENTLIST; do
	kubectl -n rook-ceph scale --replicas=0 deployment $i
done

# Patch, and Disable all the daemonsets
DAEMONSET_LIST="csi-cephfsplugin csi-rbdplugin rook-discover"
for i in $DAEMONSET_LIST; do
	kubectl -n rook-ceph patch daemonset $i -p '{"spec": {"template": {"spec":{"nodeSelector":{"nonexisting":"true"}}}}}'
done
