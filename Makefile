all:
	sudo singularity build python36.sif python36.img
	sudo singularity build mantid.sif mantid.img
	# This build expects the AR repo to be at ../autoreduce, relative to this folder
	sudo singularity build queue_processor.sif queue_processor.img

system:
	sudo yum install -y squashfs-tools
	wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz
	sudo ln -s /usr/local/go/bin/go /usr/bin/go
	sudo ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt

singularity:
	export VERSION=3.7.0 && wget https://github.com/hpcng/singularity/releases/download/v$${VERSION}/singularity-$${VERSION}.tar.gz && tar -xzf singularity-$${VERSION}.tar.gz && cd singularity
	./mconfig && make -C builddir && sudo make -C builddir install
	sudo ln -s /usr/local/bin/singularity /usr/bin/singularity

deps: system singularity

run:
	# The bind expects the AR repo to be at ../autoreduce, relative to this folder
	singularity run --bind ../autoreduce:/autoreduce/ --bind /instrument:/instrument --bind /isis:/isis queue_processor.sif

instance:
	singularity instance start --bind ../autoreduce:/autoreduce/ --bind /instrument:/instrument --bind /isis:/isis queue_processor.sif queue_processor
