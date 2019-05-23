const Tag = ({ tag }) => (
  <span className="tag-label small text-muted">#{tag}</span>
)

const ConversationTagList = props => (
  <div className="tag-label-list">
    {props.tags.map(tag => (
      <Tag tag={tag} key={tag} />
    ))}
  </div>
)
