pipeline {
	agent {
		docker {
			image 'wild/archlinux-dlang'

			args '-v ${WORKSPACE}:/workspace:ro'
		}
	}
	environment {
		TARGET = 'x86_64-powernex'
		PREFIX = '/opt/cc'
		BINUTILS_VERSION = 'binutils-2.26.1'
		GDB_VERSION = 'gdb-7.11'
	}
	stages {
		stage('dependencies') {
			steps {
				sh 'pacman -S --noconfirm curl git'
			}
		}

		stage('fetch') {
			steps {
				sh 'curl -s http://ftp.gnu.org/gnu/binutils/${BINUTILS_VERSION}.tar.gz | tar x --no-same-owner -z'
				sh 'curl -s http://ftp.gnu.org/gnu/gdb/${GDB_VERSION}.tar.gz | tar x --no-same-owner -zv'

				sh 'patch -p0 -i - </workspace/${BINUTILS_VERSION}.patch'
				sh 'patch -p0 -i - </workspace/${GDB_VERSION}.patch'
			}
		}

		stage('build-binutils') {
			steps {
				sh '''
				mkdir binutils-build
				pushd binutils-build
				../${BINUTILS_VERSION}/configure --enable-gold --enable-plugins --target=${TARGET} --prefix="${PREFIX}" --with-sysroot --disable-nls --disable-werror
				make -j
				make install -j
				popd

				rm -rf ${BINUTILS_VERSION} binutils-build
				'''
			}
		}

		stage('build-gdb') {
			steps {
				sh '''
				mkdir gdb-build
				pushd gdb-build
				../${GDB_VERSION}/configure --prefix="${PREFIX}" --disable-nls
				make -j
				make install -j
				popd

				rm -rf ${GDB_VERSION} gdb-build
				'''
			}
		}

		stage('archive') {
			steps {
				sh '''
				cd ${PREFIX}
				tar -cvfJ powernex-binutils.tar.xz *
				'''
				archiveArtifacts artifacts: 'powernex-binutils.tar.xz', fingerprint: true
			}
		}
	}

}
