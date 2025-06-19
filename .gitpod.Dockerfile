# Base image: Native Kali Linux for maximum compatibility and minimal size.
FROM kalilinux/kali-rolling

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update, upgrade, and install a curated toolset in a single layer to optimize size.
RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
    # --- Gitpod Essentials ---
    git \
    sudo \
    curl \
    tini \
    # --- Tools for Report Vulnerabilities ---
    # For 'Advanced SQL Injection' (HIGH severity) [2]
    sqlmap \
    # For general web vulnerability testing [1][2]
    burpsuite \
    # For file retrieval and scripting
    wget \
    # Python + Pip are required for git-dumper
    python3 \
    python3-pip \
    # --- User Experience (UX) Enhancements ---
    # Shells and terminal multiplexers
    zsh \
    tmux \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    # Common editors
    nano \
    vim && \
    # --- Install Python-based tool ---
    # For 'Git Configuration - Detect' (MEDIUM severity) [1][2]
    pip3 install --upgrade pip && \
    pip3 install git-dumper && \
    # --- Gitpod User Setup ---
    # This is critical for the image to work in Gitpod.
    useradd -l -u 33333 -m -s /bin/zsh gitpod && \
    echo "gitpod ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    # --- Configure Zsh for the gitpod user ---
    # This command needs to run as the gitpod user or target the user's home directory.
    # We will add it to the system-wide .zshrc which gitpod's new user will inherit.
    echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /etc/zsh/zshrc && \
    echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /etc/zsh/zshrc && \
    # --- Cleanup ---
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch to the non-privileged user for the workspace environment.
USER gitpod
WORKDIR /workspace

# The CMD is not strictly necessary as Gitpod will override it,
# but it's good practice for running the container elsewhere.
CMD [ "zsh" ]
