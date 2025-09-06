#!/bin/bash

echo "Number of hkl files"
find . -name "*.hkl" | grep -v -e spiketrain -e mountains | wc -l

echo "Number of mda files"
find mountains -name "firings.mda" | wc -l

#echo "Time taken (s)"
#tail rplpl-slurm*.out rplspl-slurm*.out

# Collect relevant out files (both patterns), sorted by name
files=( rs*-slurm*.out rplspl-slurm*.out ) 
IFS=$'\n' files=($(printf '%s\n' "${files[@]}" | sort)) || true

echo "#==========================================================="
echo "Start Times"
for f in "${files[@]}"; do
  echo "==> $f <=="
  # First line of the file is treated as the start time
  head -n 1 "$f"
  echo
done

echo "End Times"
for f in "${files[@]}"; do
  echo "==> $f <=="
  # Find the last occurrence of time.struct_time and print from there to EOF
  last_ts_line="$(grep -n 'time.struct_time' "$f" | tail -n 1 | cut -d: -f1 || true)"
  if [[ -n "${last_ts_line:-}" ]]; then
    tail -n +"$last_ts_line" "$f"
  else
    # Fallback: if no timestamp found, just show the last 10 lines
    tail -n 10 "$f"
  fi
  echo
done
echo "#==========================================================="
