# Build Instructions

## Requirements

---

### Compilation  Requirements

Ensure your system has all the necessary packages installed:

```bash
sudo apt-get install -y --no-install-recommends make autoconf automake bison flex gcc g++ \
gawk libncurses5-dev pkg-config libconfuse-dev libssl-dev python3 python3-pip python-is-python3 \
cmake libyaml-dev scons mtools bzip2 curl git openssh-client rsync dosfstools ca-certificates
```

Additionally, install Python packages using `pip`:

```bash
pip3 install pycryptodome gmssl scons==3.1.2
```

### Repository Requirements

To manage the source code, you need to install the `repo` tool:

1. Create a directory for the `repo` binary and add it to your `PATH`:

   ```bash
   mkdir -p ~/.bin
   export PATH="${HOME}/.bin:${PATH}"
   ```

2. Download the `repo` script and make it executable:

   ```bash
   curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
   chmod a+rx ~/.bin/repo
   ```

3. Persist the `PATH` change by adding it to your shell configuration file (e.g., `~/.bashrc`):

   ```bash
   echo 'export PATH="${HOME}/.bin:${PATH}"' >> ~/.bashrc
   source ~/.bashrc
   ```

## Building the Project

---

### Get the Source Code

Initialize and sync the repository to get download the source code:

```bash
# from the XIAORGEEK forked manifest with ssh
repo init -u git@github.com:xr-esp-private/manifest.git -b chore/xiaorgeek-fork-manifest --repo-url=https://github.com/canmv-k230/git-repo.git

repo sync
```

### Build for a Specific Board

1. **Download the toolchain** (only required for the first build):

   ```bash
   make dl_toolchain
   ```

2. **List all available configurations**:

   ```bash
   make list_def
   ```

3. **Select a configuration** for your board:

   ```bash
   make k230_canmv_defconfig  # Replace with the appropriate defconfig for your board
   ```

4. **Start the build process**:

   ```bash
   time make log
   ```

This process will compile the software tailored to your selected board configuration.

### XIAORGEEK Build Example

For the XIAORGEEK custom board workflow:

```bash
cd k230_sdk
python3 -m venv .venv
. .venv/bin/activate
pip install -U pip
pip install pycryptodome gmssl scons==3.1.2

make dl_toolchain
./build_k230.sh
```

Notes:

- The forked manifest already points `k230_sdk`, `u-boot` and `xrsdcard` to the
  XIAORGEEK repositories, so no extra local manifest or remote rewrite step is
  needed.
- `build_k230.sh` uses the current `HOME` by default, so it works on a new
  machine without hardcoding `/home/ceoifung/work`.
- The generated image is placed under `output/k230_canmv_xiaorgeek_defconfig/`.

## How to Contribute to This Project

---

This project is open-source and welcomes contributions.
For detailed information on how to contribute, please refer to the [CONTRIBUTING.md](CONTRIBUTING.md) file.
