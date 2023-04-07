# Video Converter to H.265 (HEVC) using GPU

This PowerShell script converts video files in a directory and its subdirectories to the H.265 (HEVC) format using your GPU, then removes the original video files and displays the total space saved.

## Requirements

- [FFmpeg](https://ffmpeg.org/download.html) installed and added to your PATH
- Supported GPU for hardware encoding (NVIDIA, AMD, or Intel)

## Usage

1. Save the `convert_to_h265.ps1` script to the directory containing the video files you want to convert.
2. Open PowerShell and navigate to the directory containing the video files and the script.
3. Run the script by typing `.\convert_to_h265.ps1` and pressing Enter.

The script will convert all video files in the current directory (and its subdirectories) to the H.265 format using your GPU, then remove the original video files and display the total space saved.

## Note

The script assumes you have an NVIDIA GPU with NVENC support. If you have a different GPU, you may need to change the `-c:v hevc_nvenc` flag in the script to the appropriate GPU encoder for your hardware (e.g., `-c:v hevc_amf` for AMD GPUs or `-c:v hevc_qsv` for Intel Quick Sync Video).

## License

This project is licensed under the [MIT License](LICENSE).
