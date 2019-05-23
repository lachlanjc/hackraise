/*= require js-md5 */

var gravatarId = function gravatarId(email) {
  return md5(email.toLowerCase())
}

const gravatarUrl = (email, size) =>
  'https://secure.gravatar.com/avatar/' +
  gravatarId(email) +
  '?d=identicon&size=' +
  size +
  '.png'

const Avatar = props => {
  let size = props.size
  if (size === 'small') {
    size = 26
  }

  return (
    <img
      className="avatar"
      src={gravatarUrl(props.person.email, size * 2)}
      width={size}
      height={size}
    />
  )
}
