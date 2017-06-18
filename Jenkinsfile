pipeline {
	agent {
		docker {
			image 'wild/archlinux-dlang'
		}
	}
	environment {
		TARGET = 'x86_64-powernex'
		PREFIX = '/opt/cc'
		BINUTILS_VERSION = 'binutils-2.28'
		GDB_VERSION = 'gdb-8.0'
	}
	stages {
		stage('fetch') {
			steps {
				sh '''

				rm -rf ${BINUTILS_VERSION} ${GDB_VERSION} binutils-build gdb-build || true

				curl -s http://ftp.gnu.org/gnu/binutils/${BINUTILS_VERSION}.tar.gz | tar x --no-same-owner -z
				curl -s http://ftp.gnu.org/gnu/gdb/${GDB_VERSION}.tar.gz | tar x --no-same-owner -zv

				patch -p0 -i - <${BINUTILS_VERSION}.patch
				patch -p0 -i - <${GDB_VERSION}.patch
				'''
			}
		}

		stage('build-binutils') {
			steps {
				sh '''
				mkdir binutils-build || true
				pushd binutils-build
				../${BINUTILS_VERSION}/configure --enable-gold --enable-plugins --target=${TARGET} --prefix="${PREFIX}" --with-sysroot --disable-nls --disable-werror
				make -j
				make install -j
				popd

				rm -rf ${BINUTILS_VERSION} binutils-build || true
				'''
			}
		}

		stage('build-gdb') {
			steps {
				sh '''
				mkdir gdb-build || true
				pushd gdb-build
				../${GDB_VERSION}/configure --prefix="${PREFIX}" --disable-nls
				make -j
				make install -j
				popd

				rm -rf ${GDB_VERSION} gdb-build || true
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
