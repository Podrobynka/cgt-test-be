# frozen_string_literal: true

SEED_PROMPT_BODIES = [
  "realistic car 3 d render sci - fi car and sci - fi robotic factory structure in the coronation of napoleon painting and digital billboard with point cloud in the middle, unreal engine 5, keyshot, octane, artstation trending, ultra high detail, ultra realistic, cinematic, 8 k, 1 6 k, in style of zaha hadid, in style of nanospace michael menzelincev, in style of lee souder, in plastic, dark atmosphere, tilt shift, depth of field,",
  "a comic potrait of a female necromamcer with big and cute eyes, fine - face, realistic shaded perfect face, fine details. night setting. very anime style. realistic shaded lighting poster by ilya kuvshinov katsuhiro, magali villeneuve, artgerm, jeremy lipkin and michael garmash, rob rey and kentaro miura style, trending on art station",
  "steampunk market interior, colorful, 3 d scene, greg rutkowski, zabrocki, karlkka, jayison devadas, trending on artstation, 8 k, ultra wide angle, zenith view, pincushion lens effect",
  "A full portrait of a beautiful post apocalyptic offworld nanotechnician, intricate, elegant, highly detailed, digital painting, artstation, concept art, smooth, sharp focus, illustration, art by Krenz Cushart and Artem Demura and alphonse mucha"
].freeze

def create_seed_prompts
  SEED_PROMPT_BODIES.map { |body| FactoryBot.create(:prompt, body: body) }
end

FactoryBot.define do
  factory :prompt do
    body { "A portrait of a cyborg in a golden suit, D&D sci-fi, artstation, concept art, highly detailed illustration." }
    trait :reindex do
      after(:create) do |prompt, _|
        prompt.reindex(refresh: true)
      end
    end
  end
end
