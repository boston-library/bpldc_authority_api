# frozen_string_literal: true

include Bpldc::LcVocabUtilities

### AUTHORITIES ###
AUTHORITY_INPUTS = [
    { code: 'aat', base_url: 'http://vocab.getty.edu/aat',
      name: 'Art and Architecture Thesaurus', subjects: true, genres: true },
    { code: 'geonames', base_url: 'http://sws.geonames.org',
      name: 'GeoNames', geographics: true },
    { code: 'gmgpc', base_url: 'http://id.loc.gov/vocabulary/graphicMaterials',
      name: 'Thesaurus for Graphic Materials', genres: true },
    { code: 'homoit', base_url: 'http://homosaurus.org/v2',
      name: 'Homosaurus LGBTQ vocabulary', subjects: true, genres: true },
    { code: 'iso639-2', base_url: 'http://id.loc.gov/vocabulary/iso639-2',
      name: 'ISO639-2 Languages' },
    { code: 'lcgft', base_url: 'http://id.loc.gov/authorities/genreForms',
      name: 'Library of Congress Genre/Form Terms', genres: true },
    { code: 'lctgm', base_url: 'http://id.loc.gov/vocabulary/graphicMaterials',
      name: 'Thesaurus for Graphic Materials', subjects: true, genres: true },
    { code: 'lcsh', base_url: 'http://id.loc.gov/authorities/subjects',
      name: 'Library of Congress Subject Headings', subjects: true, genres: true, geographics: true },
    { code: 'local', name: 'local', subjects: true, genres: true, names: true },
    { code: 'naf', base_url: 'http://id.loc.gov/authorities/names',
      name: 'Library of Congress Name Authority File', subjects: true, names: true },
    { code: 'marcgt', base_url: 'http://id.loc.gov/vocabulary/genreFormSchemes/marcgt',
      name: 'MARC genre terms', genres: true },
    { code: 'marcrelator', base_url: 'http://id.loc.gov/vocabulary/relators',
      name: 'MARC Relators Scheme' },
    { code: 'mesh', base_url: 'https://id.nlm.nih.gov/mesh',
      name: 'Medical Subject Headings', subjects: true },
    { code: 'rbmscv', base_url: 'http://id.loc.gov/vocabulary/rbmscv',
      name: 'Controlled Vocabulary for Rare Materials Cataloging', genres: true },
    { code: 'resourceTypes', base_url: 'http://id.loc.gov/vocabulary/resourceTypes',
      name: 'Resource Types Scheme' },
    { code: 'tgn', base_url: 'http://vocab.getty.edu/tgn',
      name: 'Thesaurus of Geographic Names', geographics: true },
    { code: 'ulan', base_url: 'http://vocab.getty.edu/ulan',
      name: 'Getty Union List of Artist Names', subjects: true, names: true },
    { code: 'viaf', base_url: 'http://viaf.org/viaf',
      name: 'Virtual International Authority File', subjects: true, names: true }
].freeze

puts 'Seeding Bpldc::Authority values'
AUTHORITY_INPUTS.each do |auth_input|
  Bpldc::Authority.transaction do
    begin
      Bpldc::Authority.where(auth_input).first_or_create!
    rescue StandardError => e
      puts "Failed to seed Bpldc::Authority with the following input #{auth_input.inspect}"
      puts e.inspect
    end
  end
end

### LICENSES ###
LICENSE_INPUTS = [
    { label: 'No known restrictions on use.' },
    { label: 'This work is in the public domain under a Creative Commons No Rights Reserved License (CC0).' },
    { label: 'This work is licensed for use under a Creative Commons Attribution License (CC BY).', uri: 'https://creativecommons.org/licenses/by/4.0/' },
    { label: 'This work is licensed for use under a Creative Commons Attribution Share Alike License (CC BY-SA).', uri: 'https://creativecommons.org/licenses/by-sa/4.0/' },
    { label: 'This work is licensed for use under a Creative Commons Attribution No Derivatives License (CC BY-ND).', uri: 'https://creativecommons.org/licenses/by-nd/4.0/' },
    { label: 'This work is licensed for use under a Creative Commons Attribution Non-Commercial License (CC BY-NC).', uri: 'https://creativecommons.org/licenses/by-nc/4.0/' },
    { label: 'This work is licensed for use under a Creative Commons Attribution Non-Commercial Share Alike License (CC BY-NC-SA).', uri: 'https://creativecommons.org/licenses/by-nc-sa/4.0/' },
    { label: 'This work is licensed for use under a Creative Commons Attribution Non-Commercial No Derivatives License (CC BY-NC-ND).', uri: 'https://creativecommons.org/licenses/by-nc-nd/4.0/' },
    { label: 'All rights reserved.' },
    { label: 'Contact host institution for more information.' }
].freeze

puts 'Seeding Bpldc::License values'
LICENSE_INPUTS.each do |license_input|
  Bpldc::License.transaction do
    begin
      Bpldc::License.where(license_input).first_or_create!
    rescue StandardError => e
      puts "Failed to seed Bpldc::License for the following input #{license_input.inspect}"
      puts e.inspect
    end
  end
end

## RIGHTS STATEMENTS ##
# from https://rightsstatements.org/en/statements/
RIGHTS_STATEMENTS = [
    { label: 'In Copyright', uri: 'http://rightsstatements.org/vocab/InC/1.0/' },
    { label: 'In Copyright - EU Orphan Work', uri: 'http://rightsstatements.org/vocab/InC-OW-EU/1.0/' },
    { label: 'In Copyright - Educational Use Permitted', uri: 'http://rightsstatements.org/vocab/InC-EDU/1.0/' },
    { label: 'In Copyright - Non-Commercial Use Permitted', uri: 'http://rightsstatements.org/vocab/InC-NC/1.0/' },
    { label: 'In Copyright - Rights-Holder(s) Unlocatable Or Unidentifiable', uri: 'http://rightsstatements.org/vocab/InC-RUU/1.0/' },
    { label: 'No Copyright - Contractual Restrictions', uri: 'http://rightsstatements.org/vocab/NoC-CR/1.0/' },
    { label: 'No Copyright - Non-Commercial Use Only', uri: 'http://rightsstatements.org/vocab/NoC-NC/1.0/' },
    { label: 'No Copyright - Other Known Legal Restrictions', uri: 'http://rightsstatements.org/vocab/NoC-OKLR/1.0/' },
    { label: 'No Copyright - United States', uri: 'http://rightsstatements.org/vocab/NoC-US/1.0/' },
    { label: 'Copyright Not Evaluated', uri: 'http://rightsstatements.org/vocab/CNE/1.0/' },
    { label: 'Copyright Undetermined', uri: 'http://rightsstatements.org/vocab/UND/1.0/' },
    { label: 'No Known Copyright', uri: 'http://rightsstatements.org/vocab/NKC/1.0/' }
].freeze

puts 'Seeding Bpldc::RightsStatement values'
RIGHTS_STATEMENTS.each do |rights_statement_input|
  Bpldc::License.transaction do
    begin
      Bpldc::RightsStatement.where(rights_statement_input).first_or_create!
    rescue StandardError => e
      puts "Failed to seed Bpldc::RightsStatement for the following input #{rights_statement_input.inspect}"
      puts e.inspect
    end
  end
end

### BASIC GENRES ###
BASIC_GENRE_INPUTS = {
  'gmgpc' => %w(tgm001686 tgm003185 tgm003279 tgm003634 tgm012286 tgm006261 tgm007393
                tgm007721 tgm008104 tgm008237 tgm007641 tgm001221 tgm000229),
  'lctgm' => %w(tgm002590 tgm007159 tgm007068 tgm009874 tgm006804 tgm006926 tgm006906),
  'lcgft' => %w(gf2014026174)
}.freeze

BASIC_GENRE_INPUTS.each do |auth_code, ids_from_auth|
  ids_from_auth.each do |id_from_auth|
    lc_vocab_path = auth_code == 'lcgft' ? 'authorities/genreForms' : 'vocabulary/graphicMaterials'
    LcVocabFetcher.seed_lc_data(bpldc_class: 'Bpldc::BasicGenre',
                                lc_url: "https://id.loc.gov/#{lc_vocab_path}/#{id_from_auth}.madsrdf.json",
                                auth_code: auth_code)
  end
end

### RESOURCE TYPES ###
LcVocabFetcher.seed_lc_data(bpldc_class: 'Bpldc::ResourceType',
                            lc_url: 'https://id.loc.gov/vocabulary/resourceTypes.json',
                            skip: %w(unk resourceTypes), auth_code: 'resourceTypes')

### ROLES ###
LcVocabFetcher.seed_lc_data(bpldc_class: 'Bpldc::Role',
                            lc_url: 'https://id.loc.gov/vocabulary/relators.json',
                            skip: ['relators'], auth_code: 'marcrelator')

### LANGUAGES ###
LcVocabFetcher.seed_lc_data(bpldc_class: 'Bpldc::Language',
                            lc_url: 'https://id.loc.gov/vocabulary/iso639-2.json',
                            skip: %w(iso639-2 zxx qaa-qtz mis mul und), auth_code: 'iso639-2')
