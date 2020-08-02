#!/bin/sh

codesign --verbose --force --deep -o runtime \
    --sign "Developer ID Application" \
    "../framework/Sparkle.framework/Versions/A/Resources/AutoUpdate.app"
codesign --verbose --force -o runtime \
    --sign "Developer ID Application" \
    "../mimiq/ffmpeg"
codesign --verbose --force -o runtime \
    --sign "Developer ID Application" \
    "../mimiq/mimiq"