---
layout: post
title: First steps with Docker
author: Osvaldo
header-img: "img/vineyard.jpg"
tags: [docker, replicability, software development, devops]
---

You might have read or heard that science, I mean academic science, has a few
[problems](http://www.vox.com/2016/7/14/12016710/science-challeges-research-funding-peer-review-process),
among these a [reproducibility
crisis](http://www.vox.com/2016/7/14/12016710/science-challeges-research-funding-peer-review-process#3).

Although the terms are often used interchangeably, there is an important
difference between reproducibility and replicability. The former is the ability
to repeat some analysis thanks to the fact that sufficient detail has been
shared by those who performed it first. Replicability is the probability
that an independent experiment will reach the same results and conclusions that
were first reported.

A data scientist is typically responsible for the analysis of data that have
been produced in the lab (or in the field) by someone else, so he/she is
primarily responsible to guarantee its reproducibility. This shouldn't be too
hard, since all you have to do is 1) saying which data were analyzed and 2) how
exactly. You share both and you are done; certainly easier than replicate a
complex and usually expensive experiment. Rmarkdown documents (by the way, this
blog is written in Rmarkdown) and Python notebook have become popular in recent
years also because they address this need.

For more complex projects, where multiple tools are needed, it can be more
complicated than that, and it is recognized that much of the scientific
literature is hard to reproduce. Reasons for this are largely to be found in a
lack of right incentives, but there are several remarkable technical challenges
posed by the large number of factors that influence the results. Even if we
only consider the analysis part, the huge variety of available systems makes
reproducibility challenging.
_You performed the analysis on a Linux cluster, will it run the same on a Mac
OS X? If you ran Python 3.4, will it still work and give the same results with
Python 3.5.1? Do I have to update that library, or is the one I have already
installed recent enough? And I'm still missing that dependency..._

## Full virtualization

Virtual machines (VM), which I understand were created for entirely different
reasons, offer a possible way to make replication easier.
The researcher can setup an environment to run the analysis, then make an image
of this and share it. Another user who wants to reproduce the analysis can
launch this image with a VM and it will be like sitting at the same computer:
everything exactly the same.

This solution presents a few disadvantages. Images are pretty big objects,
often in the order of several gigabytes. Moving them around is fairly
inconvenient, to begin with. Further, a VM takes in the order of minutes to
launch. Not too much for a one time analysis, still slightly annoying. In
general, VMs tend to be quite heavy on the hardware.

## Enter containers

Containers offer a light-weight option to VMs. They are usually smaller and,
above all, they are launched in a second or less.

I've been recently developing a [pipeline](http://github.com/ozagordi/VirMet)
for the analysis of DNA sequences that relies on many external tools. As it is
customary in academia, the plan is to "advertise" it with a scientific paper
and hope that many other users will find it useful, use it and cite it. But
installing ten other tools is certainly a disincentive.

So, I recently looked into [Docker](https://www.docker.com), which is now
probably the most famous containerisation software.

A developer usually starts from one of the images found in Docker Hub and adds
the necessary configuration by writing a `Dockerfile`. Each instruction in this
file is a layer, in docker terms, and the engine builds the image by stacking
these layers in an optimized way. The resulting image can be made available to
others via Docker Hub. In this way one can make available to the community an
environment in which the application is certainly running as expected. The
advantages of Docker over VMs are not limited to being light and fast. The
presence of a central directory and the possibility to develop images easily
and in an open format both make Docker interesting. It must be said that at the
same time this poses a small risk: making dozens of images for every possible
little project that one makes and pushing it onto the hub.
