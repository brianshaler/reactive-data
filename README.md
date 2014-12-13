# reactive-data

Experimental method for subscribing to streams and updating data in react components.

Watch out, this is very beta. So, so beta.

## Install in Node

`npm install reactive-data`

## Usage:

```js
var ReactiveData = require('reactive-data');
var collection = ReactiveData.Item({
  key: 'uid',
  stateKey: 'myList'
});
var reactComponent = new MyComponent({
  collection: collection
});

// In MyComponent:
React.createClass({
  [...]
  componentDidMount: function () {
    @props.collection.listen(this);
    // On update, automatically calls
    // this.setState({myList: [ReactiveData.Item, ...]});
    // if stateKey was set
    // Otherwise, listen using
    // @props.collection.on('update', function (newValue) {
    //   // do something
    // });
  },
  componentWillUnmount: function () {
    @props.collection.unlisten(this);
  },
  [...]
});
```