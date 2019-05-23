const ConversationParticipantList = props => {
  var creatorName = null
  var creatorEmail = null
  var participants = null

  if (props.creator.name) {
    creatorName = (
      <div className="conversation-creator-name">{props.creator.name}</div>
    )
  }

  creatorEmail = (
    <div className="conversation-creator-email">{props.creator.email}</div>
  )

  if (props.participants.length > 1) {
    participants = (
      <div className="conversation-participants-count">
        + {props.participants.length - 1} more
      </div>
    )
  }

  return (
    <div className="conversation-participants">
      {creatorName}
      {creatorEmail}
      {participants}
    </div>
  )
}
