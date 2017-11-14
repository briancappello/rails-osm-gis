import React from 'react'

import format from 'date-fns/format'

export default ({ date }) =>
  <span className="date">{format(date, 'MMMM Mo, YYYY [at] h:mm A')}</span>
