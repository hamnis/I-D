---
title: The 'publish' link relation
abbrev: 
docname: draft-hamnaberg-publish-link-relation-00
date: 2014
category: info

ipr: trust200902
area: General
workgroup: appswg
keyword: Internet-Draft

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 -
    ins: E. Hamnaberg
    name: Erlend Hamnaberg
    organization: 
    email: erlend@hamnaberg.net
    uri: http://www.hamnis.org/

normative:
  RFC2119:
  RFC5988:
  RFC5023:

informative:
  RFC2169:


--- abstract
This memo defines a 'publish' link relation and provides 
a number of examples.

--- middle

Introduction
============

This specification outlines the `publish` link relation and what it 
means to publish something. The specification will register the relation
according to {{RFC5988}}.

No assumptions will be made about which media type the target IRI will 
accept, but some examples and guidelines will be given.


Notational Conventions
----------------------

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{RFC2119}}.


Publishing
============
What does it mean to publish something? In effect it can be interpreted
as making something available for general consumption. 

A newspaper can publish an article, then it can be read by 'everyone'. 

A publisher can publish a book, so it can be read. 

A video can be submitted to youtube so it can be watched.


The 'publish' link relation
----------------------
The `publish` link relation allows a resource to be published using the target
IRI. 

Clients SHOULD use an appropriate write method of the target IRI protocol
uniform interface.

Clients SHOULD use a POST request when using HTTP.

Servers MAY ignore the request to publish something if the resource 
URI is already published.

Examples can be found in {{exp}}

IANA Considerations
===================

IANA is asked to register the link relation `publish`, as per {{RFC5988}}

Relation Name:

publish

Description:

Allows resources to be published using the target IRI.

Reference:

 [ this document ]


Security Considerations
=======================
TBD

--- back

Examples    {#exp}
=========

Let's say you have an atom feed like the one below

~~~~~
  <?xml version="1.0" encoding="utf-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom"
        xmlns:app="http://www.w3.org/2007/app">
    <title>Content feed</title>
    <updated>2005-07-31T12:29:29Z</updated>
    <id>tag:example.org,2003:3</id>
    <link rel="self" type="application/atom+xml"
        href="http://example.org/feed"/>
    <link rel="publish" 
      href="http://example.org/publish"/>
    <entry>
      <title>Item 1</title>
      <link rel="edit"
         href="http://example.org/item/1"/>
      <id>urn:id:1</id>
      <app:control>
        <app:draft>yes</app:draft>
    <app:control> 
      <updated>2012-05-04T12:00:29Z</updated>
      <author>
        <name>Erlend Hamnaberg</name>
      </author>
      <content type="text">
        Some Content here.
      </content>
    </entry>
    <entry>
      <title>Item 2</title>
      <link rel="edit"
         href="http://example.org/item/2"/>
      <id>urn:id:1</id>
      <app:control>
        <app:draft>yes</app:draft>
    <app:control>
      <updated>2012-05-04T12:29:29Z</updated>
      <author>
        <name>Erlend Hamnaberg</name>
      </author>
      <content type="text">
        Some Content here.
      </content>
    </entry>
  </feed>
~~~~~

Using Atompub ({{RFC5023}}), a Client would have to GET each 
entry using it's `edit` relation and PUT each back with
  
~~~~~  
  <app:draft>no</app:draft>
~~~~~

being the only change in both entries.

This is highly inefficient. So let us find a better way.

Publishing multiple resources
-----------------------------

To be able to publish many resources at once we need a 
representation which allows this. 

Appendix A in {{RFC2169}} defines the `text/uri-list` media type.

Extra linefeeds are for display purposes only.

~~~~~
  POST /publish
  Host: example.org
  Content-Type: text/uri-list
  
  http://example.org/item/1\r\n
  http://example.org/item/2\r\n
~~~~~

The problem with this approach is that is is a separate resource, 
and will not invalidate the caches of the feed. This problem is also apparent 
in the single item approach.

One might mediate this by making the feed resource also accept
`text/uri-list` for publishing. This could even be indicated in the 
`app:collection` element like this:
 
~~~~~ 
  <app:collection>
    <app:accept>text/uri-list</app:accept>
    <app:accept>application/atom+xml;type=entry</app:accept>
  </app:collection>
~~~~~

We could then change the request to this:

~~~~~
  POST /feed
  Host: example.org
  Content-Type: text/uri-list
  
  http://example.org/item/1\r\n
  http://example.org/item/2\r\n
~~~~~
