const Archive = props => (
  <div className="row">
    <div className="col-md-8 col-md-offset-2">
      <ConversationList accountSlug={props.accountSlug} archived />
    </div>
  </div>
)
