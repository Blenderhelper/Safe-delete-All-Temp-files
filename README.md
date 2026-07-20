SYSTEM CLEANUP SCRIPT 
PURPOSE AND ARCHITECTURE                 
 
OVERVIEW: 
This automated Windows batch script is designed to optimise system storage 
and maintain privacy by purging redundant temporary caches, log files, 
and leftover update installers that accumulate during normal OS operations. 
 
CORE OBJECTIVES: 
1. Storage Recovery: Frees up gigabytes of drive space by eliminating junk. 
2. Performance Maintenance: Trims overly bloated directory indexes. 
3. Zero-Interruption Execution: Operates silently without prompt fatigue. 
 
OPERATIONAL WORKFLOW: 
* Self-Elevation: Uses a dynamic VBScript wrapper to securely request administrative 
  tokens (UAC) required to access restricted Windows directory trees. 
* Telemetry Baseline: Captures a byte-precise baseline snapshot of the primary 
  system drive storage capacity before running maintenance routines. 
* Targeted Cache Eviction: Targets deep hidden system paths: 
  - Local AppData Temp: Erases scrap items left behind by crashed apps. 
  - Windows System Temp: Deletes legacy background installation outputs. 
  - Prefetch Directory: Flushes old execution traces to force clean building. 
  - SoftwareDistribution: Safely dumps completed Windows Update payloads. 
* Delta Computation: Evaluates final storage, processes string-based MB math 
  to bypass 32-bit limits, and displays the exact disk space saved. 
 
SAFE CONDITIONS: 
Files and directories locked by actively running applications or critical 
operating system threads are automatically skipped, ensuring zero system crashes.# Safe-delete-All-Temp-files
One-click Windows storage cleanup tool with Batch &amp; PowerShell variants. Safely elevates to purge user temp folders, system caches, and update logs without interrupting active apps. Calculates exact space recovered down to the MB. Open-source under the MIT License—ready for instant desktop deployment.
