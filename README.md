# Deep Society
 Deep Society is a gateway that creates new ways for us to connect with people around us and understand them better.
 
## Inspiration
As a foreigner, understanding other cultures is an integral part of my life and it is a recurring theme. We wanted an accessible way to understand the values and beliefs on the cultures we partook in; sometimes it becomes difficult to understand them. Thus, it motivated us to build an AI-driven cultural educator that answers your every question and doubt in detail.

Furthermore, it is proven that we absorb knowledge faster via speech than text which inspired us to take this route of having a fully-conversational speech-2-speech application, where your guides have unique personalities and interesting backgrounds.

## What it does
Deep Society provides a suite of personalized virtual guides that can converse with you about deep thought-provoking ideas regarding culture and society. The guides' focus is to help you understand the people around you and other societies and cultures, so that you can prosper and flourish in the economy.

## How we built it
We used Flutter to build the Frontend, along with speech recognition and speech synthesis to allow for a seamless conversion between text to speech and vice versa. Moreover, the Backend was developed in Flask and deployed to Google Cloud Platform. The question answering system was a Generative-Adversarial-Network and a Transformer model to predict the next token given a prompt (GPT-3).

## Challenges we ran into
Initially, we faced roadblocks when deploying our Backend to GCP where some endpoints would randomly stop working and not function properly. Also, text to speech (TTS) was a pain to make it work decently and not sound robotic. Nevertheless, caffeine prevailed and we were able to minimize most of the challenges that we ran into and release Deep Society to the public.

## Accomplishments that we're proud of
A fully-functional application that has thought-provoking cultural interconnections achieved through conversations with AI guides.

## What we learned
- Training ML models from scratch is hard and in a hackathon it's impossible. Always use pre-trained models!
- We pivoted at least 10 times; we learned to select a useful and practical idea that can be implemented in a 36 hour hackathon.

## What's next for Deep Society
- Expand the domain of Deep Society to more than just Society and Cultures; the AI guides are not limited to only the specified domain but are destined for much more.

## Demo: Try it out!
At the moment, only an Android APK is available [here](https://github.com/Sanavesa/DeepSociety/releases/tag/release).
