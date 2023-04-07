<#
    Script: convert_to_h265.ps1

    This script converts all video files in the directory it's run in (and its subdirectories) to the mp4 h265 format using the GPU and then deletes the original video files.
    
    Instructions:
    1. Make sure you have installed FFmpeg with the appropriate GPU hardware acceleration support.
    2. Save this script to a .ps1 file, e.g., "convert_to_h265.ps1".
    3. Open a PowerShell window and navigate to the directory containing the video files.
    4. Execute the script by typing ".\convert_to_h265.ps1" and pressing Enter.

    Note: The script assumes you have an NVIDIA GPU with NVENC support. If you have a different GPU, change the "-c:v hevc_nvenc" flag to the appropriate GPU encoder for your hardware (e.g., "-c:v hevc_amf" for AMD GPUs or "-c:v hevc_qsv" for Intel Quick Sync Video).
#>

# Check if ffmpeg is installed
# This command checks if the ffmpeg command is available on the system
if (-not (Get-Command "ffmpeg" -ErrorAction SilentlyContinue)) {
    # If ffmpeg is not installed or not in the PATH, print an error message
    Write-Host "Error: ffmpeg is not installed or not in the PATH. Please install ffmpeg and try again."
    # Exit the script
    exit
}

# Define video file extensions to process
$videoExtensions = @("*.avi", "*.mkv", "*.mp4", "*.flv", "*.wmv", "*.mov")
# Get video files in the current directory and its subdirectories
$videoFiles = Get-ChildItem -Path "." -Include $videoExtensions -Recurse -File

# Initialize a variable to store the total size of original video files
$originalSize = 0

# Initialize a variable to store the total size of converted video files
$convertedSize = 0

# Loop through each video file
foreach ($videoFile in $videoFiles) {
    # Add the size of the current video file to the total original size
    $originalSize += $videoFile.Length

    # Create a temporary filename for the converted video by adding ".tmp.mp4" extension
    $newFileName = [System.IO.Path]::ChangeExtension($videoFile.FullName, ".tmp.mp4")
    # Create the final filename for the converted video by changing the extension to ".mp4"
    $finalFileName = [System.IO.Path]::ChangeExtension($videoFile.FullName, ".mp4")
    # Print the conversion process information
    Write-Host "Converting $($videoFile.Name) to $($finalFileName)"
    
    # Run the ffmpeg command to convert the video
    # Change the "-c:v hevc_nvenc" flag to the appropriate GPU encoder for your hardware
    & ffmpeg -i $videoFile.FullName -c:v hevc_nvenc -preset medium -crf 28 -c:a aac -strict -2 -movflags +faststart $newFileName -y

    # Check the exit code of ffmpeg
    if ($LASTEXITCODE -eq 0) {
        # If the conversion was successful, remove the original video file
        Remove-Item $videoFile.FullName
        # Rename the temporary converted video file to the final filename
        Rename-Item -Path $newFileName -NewName $finalFileName
        # Add the size of the converted video file to the total converted size
        $convertedSize += (Get-Item $finalFileName).Length
    }
    else {
        # If the conversion failed, print an error message
        Write-Host "Error: Failed to convert $($videoFile.Name)."
        # Remove the temporary converted video file, if it exists
        Remove-Item $newFileName -ErrorAction Ignore
    }
}

# Calculate the space saved
$spaceSaved = $originalSize - $convertedSize

# Print a message with the space saved in MB
Write-Host ("Space saved: {0:N2} MB" -f ($spaceSaved / 1MB))

# Print a message to indicate that the video conversion is complete
Write-Host "Video conversion complete."
