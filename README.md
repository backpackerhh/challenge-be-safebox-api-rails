# Safebox API Challenge

Security-ish is a security company which main business is taking care of houses and people belongings.

Their next product launch is _Safe-ish_, a remote-control safebox that they sell to their customer in order to keep
their belongings as safe as possible, providing them the ability to control their safebox remotely through a mobile app.

As you know, the API should be strong and secure enough to avoid leaks and security
issues.

## Current Status

The CEO of Security-ish, who does not have technical background, has paid for an external consultant to develop the
new release of the product.

These guys have created an [API definition](./open-api.spec.yaml) (with OpenAPI) with the main endpoints of it, but once
they start coding they broke their collaboration. So the CEO is looking for someone who could help her to create the
next version of that API.

The CEO is not techie, and he spent a lot of money to make this product a reality. So, he needs a superb implementation
of this API which helps their team to makes some business.

## Requirements

The CEO has sent us the following business requirements:

* To increase the security of the safebox, would be better if we split the step of
  interacting with it (insert and get items) into two.
    * Open the safebox (with a valid id and password) to get a token
    * Use this token lately to add or obtain items, sending it through an HTTP Header
* The token will be valid for the next **3 minutes**
* The system will block the safebox after 3 failed opening attempts (considering a failing attempt as a wrong
  combination between safebox id and password). Don’t worry about unblocking it, we don’t care about that it nowadays.

## What are we looking for?

* **A well-designed solution and architecture.** Avoid duplication, extract re-usable code
  where makes sense. We want to see that you can create an easy-to-maintain codebase.
* **Test as much as you can.** One of the main pain points of maintaining other's code
  comes when it does not have tests. So try to create tests covering, at least, the main classes.
* **Document your decisions**. The CEO has a non-tech background so try to explain your decisions,
  as well as any other technical requirement (how to run the API, external dependencies, etc ...)

---

## How to submit your solution

* Push your code to the `devel` branch - we encourage you to commit regularly to show your thinking process was.
* **Create a new Pull Request** to `main` branch & **merge it**.

Once merged you **won't be able to change or add** anything to your solution, so double-check that everything is as
you expected!

Remember that **there is no countdown**, so take your time and implement a solution that you are proud!

--- 

<p align="center">
  If you have any feedback or problem, <a href="mailto:help@rviewer.io">let us know!</a> 🤘
  <br><br>
  Made with ❤️ by <a href="https://rviewer.io">Rviewer</a>
</p>

