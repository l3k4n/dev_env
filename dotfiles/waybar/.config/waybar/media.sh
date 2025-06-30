case "$(playerctl status)" in
    "Playing")
        PERCENTAGE=2
        ;;
    "Paused")
        PERCENTAGE=1
        ;;
    "Stopped")
        PERCENTAGE=0
        ;;
    *)
        PERCENTAGE=0
        ;;
esac

# printf "{\"text\": \"$(playerctl metadata title)\", \"percentage\": $PERCENTAGE}"
printf "{\"text\": \"$(playerctl metadata title)\", \"alt\": \"$(playerctl status)\"}"
