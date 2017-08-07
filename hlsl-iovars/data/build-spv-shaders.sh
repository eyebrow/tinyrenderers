#!/bin/sh

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$#" -lt 1 ]; then
  echo "Usage: build-spv-shaders.sh <glslang path>"
  exit
fi

glslang=$1
if [ ! $(which $glslang) ];  then
  echo "glslangValidator not found at $glslang"
  exit
fi

echo "Using $glslang"

function has_file_changed()
{
  filepath=$1
  filename=$(basename $filepath)

  dirpath=$script_dir/build_files
  mkdir -p $dirpath
  md5_file=$dirpath/$filename.md5

  hash_value=$(md5sum $filepath)
  modified=$(stat -c %y $filepath)
  key="$hash_value $modified"

  if [ ! -f $md5_file ]; then
    echo "$key" > $md5_file
    echo 1
    return
  fi

  if ! grep -Fxq "$key" $md5_file
  then
    echo "$key" > $md5_file
    echo 1
    return
  fi

  echo 0
  return
}

function compile_vs() {
  filepath=$1
  entry=$2
  filename=$(basename $filepath .hlsl)
  filename=$(basename $filename .vs)
  ouptput_filename=$filename.vs.spv

  build=false
  if [ ! -f $ouptput_filename ]; then
    build=true
  fi

  if [ "$build" = false ]; then
    changed=$(has_file_changed $filepath $ouptput_filename)
    if [ $changed -eq 0 ]; then
      echo "Skipping $filepath no changes detected"
      return
    fi
  fi


  echo ""
  echo "Compiling $filepath"

  cmd="$glslang -D -V -S vert -e $entry --hlsl-iomap --auto-map-bindings --hlsl-offsets -o $ouptput_filename $filepath"
  echo $cmd
  $cmd

  echo ""
}

function compile_ps() {
  filepath=$1
  entry=$2
  filename=$(basename $filepath .hlsl)
  filename=$(basename $filename .ps)
  ouptput_filename=$filename.ps.spv

  build=false
  if [ ! -f $ouptput_filename ]; then
    build=true
  fi

  if [ "$build" = false ]; then
    changed=$(has_file_changed $filepath $ouptput_filename)
    if [ $changed -eq 0 ]; then
      echo "Skipping $filepath no changes detected"
      return
    fi
  fi


  echo ""
  echo "Compiling $filepath"

  cmd="$glslang -D -V -S frag -e $entry --hlsl-iomap --auto-map-bindings --hlsl-offsets -o $ouptput_filename $filepath"
  echo $cmd
  $cmd

  echo ""
}

function compile_cs() {
  filepath=$1
  entry=$2
  filename=$(basename $filepath .hlsl)
  ouptput_filename=$filename.cs.spv

  build=false
  if [ ! -f $ouptput_filename ]; then
    build=true
  fi

  if [ "$build" = false ]; then
    changed=$(has_file_changed $filepath $ouptput_filename)
    if [ $changed -eq 0 ]; then
      echo "Skipping $filepath no changes detected"
      return
    fi
  fi


  echo ""
  echo "Compiling $filepath"

  cmd="$glslang -D -V -S comp -e $entry --hlsl-iomap --auto-map-bindings --hlsl-offsets -o $ouptput_filename $filepath"
  echo $cmd
  $cmd

  echo ""
}

function compile_vs_ps() {
  filepath=$1
  vs_entry=$2
  ps_entry=$3
  filename=$(basename $filepath .hlsl)
  output_vs_filename=$filename.vs.spv
  output_ps_filename=$filename.ps.spv

  build_vs=false
  if [ ! -f $output_vs_filename ]; then
    build_vs=true
  fi

  build_ps=false
  if [ ! -f $output_ps_filename ]; then
    build_ps=true
  fi

  changed=$(has_file_changed $filepath)
  if [ $changed -eq 1 ]; then
    build_vs=true
    build_ps=true
  fi


  if [ "$build_vs" = false ] && [ "$build_ps" = false ]; then
    echo "Skipping $filepath no changes detected"
    return
  fi

  echo ""
  echo "Compiling $filepath"

  if [ "$build_vs" = true ]; then
    cmd="$glslang -D -V -S vert -e $vs_entry --hlsl-iomap --auto-map-bindings --hlsl-offsets -o $output_vs_filename $filepath"
    echo $cmd
    $cmd
  fi

  if [ "$build_ps" = true ]; then
    cmd="$glslang -D -V -S frag -e $ps_entry --hlsl-iomap --auto-map-bindings --hlsl-offsets -o $output_ps_filename $filepath"
    echo $cmd
    $cmd
  fi

  echo ""
}

echo ""

#compile_cs append_consume.hlsl main
#compile_cs byte_address_buffer.hlsl main
#compile_cs simple_compute.hlsl main
#compile_cs structured_buffer.hlsl main

#compile_vs_ps color.hlsl VSMain PSMain
#compile_vs_ps constant_buffer.hlsl VSMain PSMain
#compile_vs_ps opaque_args.hlsl VSMain PSMain
#compile_vs_ps passing_arrays.hlsl VSMain PSMain
#compile_vs_ps texture.hlsl VSMain PSMain
#compile_vs_ps uniformbuffer.hlsl VSMain PSMain

compile_vs Ex01.vs.hlsl main
compile_ps Ex01.ps.hlsl main
compile_vs Ex02.vs.hlsl main
compile_ps Ex02.ps.hlsl main
compile_vs Ex03.vs.hlsl main
compile_ps Ex03.ps.hlsl main
compile_vs Ex04.vs.hlsl main
compile_ps Ex04.ps.hlsl main
compile_vs Ex05.vs.hlsl main
compile_ps Ex05.ps.hlsl main
compile_vs Sv01.vs.hlsl main
compile_ps Sv01.ps.hlsl main


echo ""
