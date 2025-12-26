# AWS EC2 Incident Troubleshooting Lab

## Project Overview
This project simulates real-world EC2 incidents in a controlled AWS lab environment.  
It demonstrates troubleshooting skills for cloud engineers using Linux, SSH, and AWS monitoring tools.

## Objectives
- Diagnose high CPU usage using CloudWatch and Linux tools
- Resolve connectivity issues caused by security group misconfigurations
- Troubleshoot SSH permission failures and OS-level issues
- Implement basic monitoring scripts to reduce manual checks

---

## Incidents

### Incident #0 – SSH Key / Permission Issue

| Step | Actual Output | Expected Output | Fix / Resolution |
|------|---------------|----------------|----------------|
| SSH into EC2 using key | Warning: Identity file not accessible, Permission denied | Passwordless SSH login prompt | Locate key: find ~ -name "incident-key.pem", set permissions chmod 400, SSH again |
| Check login | Cannot run commands | Login successful | Verified SSH login |

**Commands Used:**
```bash
find ~ -name "incident-key.pem"
chmod 400 ~/Downloads/incident-key.pem
ssh -i ~/Downloads/incident-key.pem ec2-user@<public-ip>
```

---

### Incident #1 – High CPU / Resource Stress

| Step | Actual Output | Expected Output | Fix / Resolution |
|------|---------------|----------------|----------------|
| Run stress command | stress: info: dispatching hogs: 2 cpu, 0 io, 0 vm, 0 hdd | CPU spike visible in CloudWatch | ✅ Expected; stress runs for 5 minutes |
| CloudWatch CPU graph | Normal CPU → spiked to ~100% | CPU spike during stress | Verified spike is correct |
| nginx status | Normal / responsive | nginx remains active | No fix needed; verified service |

**Commands Used:**
```bash
sudo dnf install -y nginx stress
sudo systemctl start nginx
sudo systemctl enable nginx
stress --cpu 2 --timeout 300
systemctl status nginx
```

---

### Incident #2 – Network / Security Group Failure

| Step | Actual Output | Expected Output | Fix / Resolution |
|------|---------------|----------------|----------------|
| SSH after removing SG port 22 | ssh: connect to host <IP> port 22: Connection timed out | Timeout expected | Restore inbound rule for port 22 in security group |
| SSH after fix | Cannot connect | SSH login works | Verified SSH connection successful |

**Steps Taken in AWS Console:**
1. Removed port 22 inbound rule from security group
2. Observed SSH timeout
3. Restored inbound rule with source = My IP
4. Tested SSH login

---

### Incident #3 – SSH OS-Level Failure

| Step | Actual Output | Expected Output | Fix / Resolution |
|------|---------------|----------------|----------------|
| SSH login after modifying .ssh/authorized_keys permissions / stopping sshd | ssh: connect to host <IP> port 22: Connection refused | Connection refused (simulated) | Correct permissions chmod 600 ~/.ssh/authorized_keys and restart SSH service sudo systemctl start sshd |
| SSH login after fix | Cannot connect | SSH login works | Verified SSH login successful |

**Commands Used:**
```bash
sudo chmod 600 /home/ec2-user/.ssh/authorized_keys
sudo systemctl start sshd
sudo systemctl status sshd
ssh -i ~/Downloads/incident-key.pem ec2-user@<public-ip>
```

---

## Commands Summary
- SSH: ssh -i ~/Downloads/incident-key.pem ec2-user@<public-ip>
- CPU stress: stress --cpu 2 --timeout 300
- Permissions fix: chmod 400 ~/Downloads/incident-key.pem, chmod 600 ~/.ssh/authorized_keys
- SSH service: sudo systemctl start sshd
- nginx: sudo dnf install -y nginx, sudo systemctl start nginx

---

## Learnings
- Hands-on troubleshooting of AWS EC2 instances
- Using CloudWatch for monitoring and diagnosis
- Understanding Linux SSH permissions and security best practices
- Managing network access through security groups
- Simulating real-world incidents safely in a lab

---

## Optional Scripts
- scripts/monitoring.sh – Monitors CPU periodically and logs metrics


## Repository Structure

- **scripts/**
  - `monitoring.sh` – Simple CPU monitoring script used during incidents
- **logs/**
  - `sample-incident.log` – Captured actual vs expected outputs
- **docs/**
  - Troubleshooting notes and observations
