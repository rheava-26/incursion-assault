# Minimal static HTTP server (no Node/Python needed) for previewing the prototypes.
# Serves files from this script's directory; "/" maps to m5.html.
# Hardened: bulletproof accept loop + per-connection timeouts so an idle/speculative
# browser socket can never deadlock the single-threaded loop.
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 8777
$mime = @{ ".html"="text/html; charset=utf-8"; ".js"="application/javascript"; ".css"="text/css";
           ".wav"="audio/wav"; ".png"="image/png"; ".jpg"="image/jpeg"; ".svg"="image/svg+xml" }
$listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, $port)
$listener.Start()
Write-Host "serving $root on http://localhost:$port/  (root -> m5.html)"
while ($true) {
  $client = $null
  try {
    $client = $listener.AcceptTcpClient()
    $client.ReceiveTimeout = 2500    # idle socket: ReadLine throws -> we move on
    $client.SendTimeout = 30000
    $stream = $client.GetStream()
    $reader = New-Object System.IO.StreamReader($stream)
    $requestLine = $reader.ReadLine()
    if ($requestLine) {
      $path = ($requestLine -split ' ')[1]
      if ([string]::IsNullOrEmpty($path) -or $path -eq '/') { $path = '/m5.html' }
      $path = ($path -split '\?')[0]
      $file = Join-Path $root ($path.TrimStart('/'))
      if (Test-Path $file -PathType Leaf) {
        $bytes = [System.IO.File]::ReadAllBytes($file)
        $ext = [System.IO.Path]::GetExtension($file).ToLower()
        $ct = $mime[$ext]; if (-not $ct) { $ct = 'application/octet-stream' }
        $header = "HTTP/1.1 200 OK`r`nContent-Type: $ct`r`nContent-Length: $($bytes.Length)`r`nCache-Control: no-store`r`nConnection: close`r`n`r`n"
        $hb = [System.Text.Encoding]::ASCII.GetBytes($header)
        $stream.Write($hb, 0, $hb.Length)
        $stream.Write($bytes, 0, $bytes.Length)
      } else {
        $body = [System.Text.Encoding]::ASCII.GetBytes("404 Not Found: $path")
        $header = "HTTP/1.1 404 Not Found`r`nContent-Length: $($body.Length)`r`nConnection: close`r`n`r`n"
        $hb = [System.Text.Encoding]::ASCII.GetBytes($header)
        $stream.Write($hb, 0, $hb.Length); $stream.Write($body, 0, $body.Length)
      }
      $stream.Flush()
    }
  } catch { }
  finally { if ($client) { try { $client.Close() } catch { } } }
}
