if [ ! -n "$WERCKER_ZULIP_NOTIFY_TOKEN" ]; then
  error 'Please specify the token property'
  exit 1
fi

STEP_NAME=""
if [ ! -n "$DEPLOY" ]; then
    STEP_NAME="build"
else
    STEP_NAME="deploy"
fi

if [ "$WERCKER_ZULIP_NOTIFY_ON" = "failed" ]; then
    if [ "$WERCKER_RESULT" = "passed" ]; then
        echo "Skipping..."
        return 0
        fi
fi

BRANCH="$WERCKER_GIT_BRANCH"
RESULT="$WERCKER_RESULT"
STARTED_BY="$WERCKER_STARTED_BY"
COMMIT_ID="$WERCKER_GIT_COMMIT"
STEP_MESSAGE="$_WERCKER_FAILED_STEP_DISPLAY_MESSAGE"

SOURCE="Wercker"
PROJECT="$APPLICATION"
APPLICATION=$(echo "$WERCKER_APPLICATION_NAME" | sed 's/[^-a-zA-Z0-9_ ]//g')
LINK="https://app.wercker.com/$WERCKER_APPLICATION_OWNER_NAME/$APPLICATION/runs/build/$WERCKER_BUILD_ID"
SUBJECT="Build $APPLICATION"
CONTENT="**$APPLICATION** Step **$STEP_NAME** of $BRANCH by $STARTED_BY **$RESULT**.\nCommit ID: $COMMIT_ID.\nLink: $LINK\nMessage: $STEP_MESSAGE"

API_URL="https://$WERCKER_ZULIP_NOTIFY_DOMAIN/api/v1/messages"

COMMAND="curl $API_URL -u $WERCKER_ZULIP_NOTIFY_BOT -d 'type=stream' -d 'to=$WERCKER_ZULIP_NOTIFY_STREAM' -d 'subject=$SUBJECT' -d $'content=$CONTENT'"
echo $COMMAND
eval $COMMAND
