import pathToRegexp from 'path-to-regexp'

const SECONDS_PER_HOUR = 60 * 60
const SECONDS_PER_DAY = 24 * SECONDS_PER_HOUR

export function durationOfTimeInWords(total_seconds) {
  const days = Math.floor(total_seconds / SECONDS_PER_DAY),
        remaining_seconds = total_seconds % SECONDS_PER_DAY,
        hours = Math.floor(remaining_seconds / SECONDS_PER_HOUR),
        minutes = Math.floor(remaining_seconds / 60) % 60,
        seconds = remaining_seconds % 60

  let parts = []
  if (days > 0) parts.push(`${days} days`)
  if (hours > 0) parts.push(`${hours} hours`)
  if (minutes > 0) parts.push(`${minutes} minutes`)
  if (seconds > 0) parts.push(`${seconds} seconds`)

  if (parts.length == 0) {
    return '0 seconds'
  }
  return parts.join(', ')
}


export function getUrlParams(pattern) {
  const tokens = []
  const re = pathToRegexp(pattern, tokens)
  const matches = re.exec(window.location.pathname)
  if (!matches) {
    return {}
  }

  const params = {}
  for (let i = 0; i < tokens.length; i++) {
    const token = tokens[i]
    params[token.name] = matches[i+1]
  }
  return params
}
