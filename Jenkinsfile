pipeline {
	agent { dockerfile true }
	environment {
		TARGET = 'x86_64-powernex'
		PREFIX = '/opt/cc'
	}
	stages {
		stage('fetch') {
			steps {
				script {
					if (env.JOB_NAME.endsWith("_pull-requests"))
						setGitHubPullRequestStatus state: 'PENDING', context: "${env.JOB_NAME}", message: "Fetching dependencies"
				}
				ansiColor('xterm') {
					sh '''#!/bin/bash
					set -xeuo pipefail
					BINUTILS_VERSION=$(cat BINUTILS_VERSION)
					GDB_VERSION=$(cat GDB_VERSION)

					rm -rf binutils-${BINUTILS_VERSION} gdb-${GDB_VERSION} binutils-build gdb-build || true

					curl -s http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.gz | tar x --no-same-owner -z
					curl -s http://ftp.gnu.org/gnu/gdb/gdb-${GDB_VERSION}.tar.gz | tar x --no-same-owner -zv

					patch -p0 -i - <binutils-${BINUTILS_VERSION}.patch
					patch -p0 -i - <gdb-${GDB_VERSION}.patch
					'''
				}
			}
		}

		stage('build-binutils') {
			steps {
				script {
					if (env.JOB_NAME.endsWith("_pull-requests"))
						setGitHubPullRequestStatus state: 'PENDING', context: "${env.JOB_NAME}", message: "Building binutils"
				}
				ansiColor('xterm') {
					sh '''#!/bin/bash
					set -xeuo pipefail
					BINUTILS_VERSION=$(cat BINUTILS_VERSION)

					mkdir binutils-build
					pushd binutils-build
					../binutils-${BINUTILS_VERSION}/configure \
						--enable-gold \
						--enable-plugins \
						--target=${TARGET} \
						--prefix="${PREFIX}" \
						--with-sysroot \
						--disable-nls \
						--disable-werror
					make -j
					make install -j
					popd

					rm -rf binutils-${BINUTILS_VERSION} binutils-build
					'''
				}
			}
		}

		stage('build-gdb') {
			steps {
				script {
					if (env.JOB_NAME.endsWith("_pull-requests"))
						setGitHubPullRequestStatus state: 'PENDING', context: "${env.JOB_NAME}", message: "Building gdb"
				}
				ansiColor('xterm') {
					sh '''#!/bin/bash
					set -xeuo pipefail
					GDB_VERSION=$(cat GDB_VERSION)

					mkdir gdb-build
					pushd gdb-build
					../gdb-${GDB_VERSION}/configure \
						--prefix="${PREFIX}" \
						--disable-nls \
						--with-system-readline \
						--with-python=/usr/bin/python3 \
						--with-guile=guile-2.0 \
						--disable-werror
					make -j
					make install -j
					popd

					rm -rf gdb-${GDB_VERSION} gdb-build
					'''
				}
			}
		}

		stage('archive') {
			steps {
				script {
					if (env.JOB_NAME.endsWith("_pull-requests"))
						setGitHubPullRequestStatus state: 'PENDING', context: "${env.JOB_NAME}", message: "Archiving binutils and gdb"
				}
				ansiColor('xterm') {
					sh '''#!/bin/bash
					set -xeuo pipefail

					pushd ${PREFIX}
					tar cvfJ powernex-binutils.tar.xz *
					popd
					mv ${PREFIX}/powernex-binutils.tar.xz .
					'''
					archiveArtifacts artifacts: 'powernex-binutils.tar.xz', fingerprint: true
				}
			}
		}
	}

  post {
    success {
			script {
				if (env.JOB_NAME.endsWith("_pull-requests"))
					setGitHubPullRequestStatus state: 'SUCCESS', context: "${env.JOB_NAME}", message: "binutils & gdb building successed"
			}
    }
		failure {
			script {
				if (env.JOB_NAME.endsWith("_pull-requests"))
					setGitHubPullRequestStatus state: 'FAILURE', context: "${env.JOB_NAME}", message: "binutils & gdb building failed"
			}
		}
  }
}
