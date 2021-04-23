PROFILE_NAME=$(kubectl get profiles -n kanister --no-headers -o jsonpath --template "{ .items[*].metadata.name }{ '\n' }")
set -x
kanctl create actionset \
    --action backup \
    --deployment timelogger/time-logger \
    --namespace kanister \
    --blueprint timelog-profile-bp \
    --profile "kanister/$PROFILE_NAME"

