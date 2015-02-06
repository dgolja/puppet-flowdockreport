#Flowdock report

##Overview

A Puppet report handler for sending notifications of Puppet runs to Flowdock.

##Installation

`puppet module install golja/influxdb`

##Usage

All interaction is done via `flowdockreport`.

*Example*

```puppet
class {'flowdockreport':
  external_user_name => 'Marvin',
  flows => {
    'production' => {
      'api' => 'API_KEY_PRODCUTION_FLOW',
      'statuses' => ['failed'],
      'mention' => ['everyone'],
      'environment' => ['production']
    },
    'staging' => {
      'api' => 'API_KEY_DEV_FLOW',
      'statuses' => ['changed', 'failed'],
    },
    'cms' => {
      'api' => 'API_KEY_FOR_CHANNEL_CMS',
      'statuses' => ['changed','failed'],
      'host' => 'azcms*',
    }
  },
}
```


##TODO

* add emoji for different type or failure

##License

See LICENSE file
