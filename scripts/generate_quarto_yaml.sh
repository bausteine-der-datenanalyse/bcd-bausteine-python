#!/bin/bash

# Set output path for combined YAML
OUTPUT_YAML="_quarto.yml"

# Start the YAML file
cat <<EOF > $OUTPUT_YAML
project:
  type: book
  output-dir: output/book/
book:
  title: "Vorlesung Ingenieurinformatik"
  author: 
    - Lukas Arnold
    - Simone Arnold
    - Florian Bagemihl
    - Matthias Baitsch
    - Marc Fehr
    - Maik Poetzsch
    - Sebastian Seipel
  date: today
  language: de-DE
  downloads: [pdf]
  repo-url: "https://github.com/FireDynamics/Vorlesung_Ingenieurinformatik"
  repo-actions: [source]
  favicon: books/shared-media/logo/favicon.svg
  sidebar:
    title: "Vorlesung Ingenieurinformatik"
    logo: books/shared-media/logo/logo_with_text.svg
  chapters:
    - index.qmd
EOF

# Define the order of submodules
SUBMODULES_ORDER=(
  "books/w-pseudocode"
  "books/w-python-minimal"
  "books/w-python"
  "books/w-python-numpy"
  "books/w-pandas"
  "books/w-python-matplotlib"
  "books/m-numerik"
  "books/m-einlesen-strukturierter-datensätze"
  "books/m-datenfitting-und-optimierung"
  "books/m-sensordatenanalyse"
  "books/a-energiedatenanalyse"
  "books/a-auswertung-fds-daten"
)

# Step 2: Append parts and chapters under one unified 'book' section
for ITEM in "${SUBMODULES_ORDER[@]}"; do
  SUBMODULE="$ITEM"  # Define SUBMODULE from ITEM
  PART_NAME=$(basename "$SUBMODULE")  # Dynamically use folder name as part title
  YAML_PATH="${SUBMODULE}/_quarto-full.yml"

  if [[ -f "$YAML_PATH" ]]; then
    CHAPTERS=$(yq eval '.book.chapters[]' "$YAML_PATH")

    echo "    - part: \"$PART_NAME\"" >> $OUTPUT_YAML
    echo "      chapters:" >> $OUTPUT_YAML
    while read -r CHAPTER; do
      echo "        - $SUBMODULE/$CHAPTER" >> $OUTPUT_YAML
    done <<< "$CHAPTERS"
  else
    echo "No _quarto.yml in $SUBMODULE, skipping..."
  fi
done

cat <<EOF >> $OUTPUT_YAML
format:
  html:
    theme: flatly
    toc: true
    toc-depth: 2
  pdf:
    number-sections: true

execute:
  freeze: auto

EOF

echo "Combined _quarto.yml with parts and chapters from submodules generated."

    
 